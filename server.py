import datetime
import sqlite3

import paho.mqtt.client as mqtt
import tkinter
import time
import sys

broker = sys.argv[1]

PRICE_MULTIPLIER = 20

client = mqtt.Client()

window = tkinter.Tk()


def process_message(client, userdata, message):
    message_decoded = (str(message.payload.decode("utf-8"))).split("@")

    client_id = get_id_from_ip(message_decoded[0])
    time_in, leaving = check_client(client_id)

    curr_time = time.ctime()
    
    if client_id is not None:
        if leaving:
            price, time_diff = count_price(time_in, curr_time)
            connection = sqlite3.connect("clients.db")
            cursor = connection.cursor()

            cursor.execute(f"UPDATE clients_log SET out_time = '{curr_time}', price = '{price}' WHERE id = '{client_id}' AND in_time = '{time_in}'")
            connection.commit()
            connection.close()

            print(f"client: {client_id} ({message_decoded[0]}) at {curr_time} get OUT | price: {price} | time: {time_diff}")
            response_client(message_decoded[0], curr_time, f"{price} @ {time_diff}")
        else:
            connection = sqlite3.connect("clients.db")
            cursor = connection.cursor()
            cursor.execute("INSERT INTO clients_log VALUES (?,?,?,?)", (client_id, curr_time, None, None))
            connection.commit()
            connection.close()
            print(f"client: {client_id} ({message_decoded[0]}) at {curr_time} get IN")
            response_client(message_decoded[0], curr_time)
    else:
        print(f"client_address_ip: {message_decoded[0]} at {curr_time} was NOT FOUND in database!")
        response_client(message_decoded[0], curr_time, "Sorry, you are not registered!")


def get_id_from_ip(client_ip):
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    command = f"SELECT * FROM clients WHERE ip_address = '{client_ip}'"
    cursor.execute(command)
    log_entries = cursor.fetchall()

    if log_entries:
        log_entry = log_entries[-1]
        return log_entry[0]
    else:
        return None


def check_client(client_id):
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    command = f"SELECT * FROM clients_log WHERE id = '{client_id}'"
    cursor.execute(command)
    log_entries = cursor.fetchall()

    if log_entries:
        log_entry = log_entries[-1]
        if log_entry[2] is None:
            return log_entry[1], True
    return None, False


def count_price(time_in, time_out):
    time_in_con = time.strptime(time_in, "%c")
    time_out_con = time.strptime(time_out, "%c")
    time_in_sec = datetime.timedelta(days=time_in_con.tm_mday, hours=time_in_con.tm_hour,
                                     minutes=time_in_con.tm_min, seconds=time_in_con.tm_sec).total_seconds()
    time_out_sec = datetime.timedelta(days=time_out_con.tm_mday, hours=time_out_con.tm_hour,
                                      minutes=time_out_con.tm_min, seconds=time_out_con.tm_sec).total_seconds()

    time_diff = time_out_sec - time_in_sec
    return round(time_diff / 60 * PRICE_MULTIPLIER, 2), time_diff


def print_log_to_window():
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM clients_log JOIN clients USING(id)")
    log_entries = cursor.fetchall()
    labels_log_entry = []
    print_log_window = tkinter.Tk()

    for log_entry in log_entries:
        labels_log_entry.append(tkinter.Label(print_log_window, text=(
            "On %s, %s, %s, %s" % (log_entry[4], log_entry[1], log_entry[2], log_entry[3]))))

    for label in labels_log_entry:
        label.pack(side="top")

    connection.commit()
    connection.close()

    print_log_window.mainloop()


def create_main_window():
    window.geometry("250x100")
    window.title("SERVER")
    exit_button = tkinter.Button(window, text="Stop", command=window.quit)
    print_log_button = tkinter.Button(
        window, text="Print log", command=print_log_to_window)

    exit_button.pack(side="right")
    print_log_button.pack(side="right")


def response_client(client_ip, time, msg=None):
    if msg is None:
        client.publish(f"client/response/{client_ip}", f"{time}")
    else:
        client.publish(f"client/response/{client_ip}", f"{time}@{msg}")
        

def connect_to_broker():
    client.connect(broker)
    client.on_message = process_message
    client.loop_start()
    client.subscribe("client/request/#")


def disconnect_from_broker():
    client.loop_stop()
    client.disconnect()


def run_receiver():
    connect_to_broker()
    create_main_window()
    window.mainloop()
    disconnect_from_broker()


if __name__ == "__main__":
    run_receiver()

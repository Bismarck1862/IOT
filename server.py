import datetime

import paho.mqtt.client as mqtt
import tkinter
import sqlite3
import time
import sys
import os

# The broker name or IP address.
broker = sys.argv[1]
# broker = "localhost"

PRICE_MULTIPLIER = 20

terminal_id = "T0"

# The MQTT client.
client = mqtt.Client()

# Thw main window.
window = tkinter.Tk()


def create_database():
    if os.path.exists("clients.db"):
        os.remove("clients.db")
        print("An old database removed.")
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    cursor.execute(""" CREATE TABLE clients_log (
        client text,
        in_time text,
        out_time text,
        price text
    )""")
    connection.commit()
    connection.close()
    print("The new database created.")


def process_message(client, userdata, message):
    # Decode message.
    message_decoded = (str(message.payload.decode("utf-8"))).split(",")

    time_in, leaving = checkClient(message_decoded[0])

    if leaving:
        price, time_diff = countPrice(time_in, time.ctime())
        # Modify to sqlite database.
        connection = sqlite3.connect("clients.db")
        cursor = connection.cursor()
        cursor.execute("UPDATE clients_log SET out_time = '{0}', price = '{1}' WHERE client = '{2}' AND in_time = "
                       "'{3}' "
                       .format(time.ctime(), price, message_decoded[0], time_in))
        connection.commit()
        connection.close()
        response_client(message_decoded[0], "{0} , {1}".format(price, time_diff))
    else:
        # Save to sqlite database.
        connection = sqlite3.connect("clients.db")
        cursor = connection.cursor()
        cursor.execute("INSERT INTO clients_log VALUES (?,?,?,?)",
                       (message_decoded[0], time.ctime(), None, None))
        connection.commit()
        connection.close()
        response_client(message_decoded[0])


def checkClient(client_name):
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    command = "SELECT * FROM clients_log WHERE client = '{0}'".format(client_name)
    cursor.execute(command)
    log_entries = cursor.fetchall()

    if log_entries:
        log_entry = log_entries[-1]
        if log_entry[2] is None:
            return log_entry[1], True
        else:
            return None, False
    else:
        return None, False


def countPrice(time_in, time_out):
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
    cursor.execute("SELECT * FROM clients_log")
    log_entries = cursor.fetchall()
    labels_log_entry = []
    print_log_window = tkinter.Tk()

    for log_entry in log_entries:
        labels_log_entry.append(tkinter.Label(print_log_window, text=(
            "On %s, %s, %s, %s" % (log_entry[0], log_entry[1], log_entry[2], log_entry[3]))))

    for label in labels_log_entry:
        label.pack(side="top")

    connection.commit()
    connection.close()

    print_log_window.mainloop()

    # return log_entries


def create_main_window():
    window.geometry("250x100")
    window.title("SERVER")
    exit_button = tkinter.Button(window, text="Stop", command=window.quit)
    print_log_button = tkinter.Button(
        window, text="Print log", command=print_log_to_window)

    exit_button.pack(side="right")
    print_log_button.pack(side="right")


def response_client(client_name, msg="Hello"):
    client.publish("client/response/{0}".format(client_name), client_name + "," + terminal_id + "," + msg,)


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
    create_database()
    run_receiver()

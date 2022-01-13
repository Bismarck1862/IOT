import datetime
import sqlite3
import csv
import paho.mqtt.client as mqtt
import tkinter
import time
import sys
from PySide2.QtCore import QObject, Signal

PRICE_MULTIPLIER = 20


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


def get_log():
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM clients_log JOIN clients USING(id)")
    log_entries = cursor.fetchall()
    labels_log_entry = []

    for log_entry in log_entries:
        labels_log_entry.append((log_entry[4], log_entry[1], log_entry[2], log_entry[3]))

    connection.commit()
    connection.close()
    labels_log_entry.reverse()
    return labels_log_entry


class Server(QObject):
    export_ready = Signal()

    client = mqtt.Client()

    def __init__(self, broker, parent=None):
        super().__init__(parent)
        self.broker = broker

    def response_client(self, client_ip, time, msg=None):
        if msg is None:
            self.client.publish(f"client/response/{client_ip}", f"{time}")
        else:
            self.client.publish(f"client/response/{client_ip}", f"{time}@{msg}")

    def connect_to_broker(self):
        self.client.connect(self.broker)
        self.client.on_message = self.process_message
        self.client.loop_start()
        self.client.subscribe("client/request/#")

    def disconnect_from_broker(self):
        self.client.loop_stop()
        self.client.disconnect()

    def process_message(self, client, userdata, message):
        message_decoded = (str(message.payload.decode("utf-8"))).split("@")

        client_id = get_id_from_ip(message_decoded[0])
        time_in, leaving = check_client(client_id)

        curr_time = time.ctime()

        if client_id is not None:
            if leaving:
                price, time_diff = count_price(time_in, curr_time)
                connection = sqlite3.connect("clients.db")
                cursor = connection.cursor()

                cursor.execute(
                    f"UPDATE clients_log SET out_time = '{curr_time}', price = '{price}' WHERE id = '{client_id}' AND in_time = '{time_in}'")
                connection.commit()
                connection.close()

                print(
                    f"client: {client_id} ({message_decoded[0]}) at {curr_time} get OUT | price: {price} | time: {time_diff}")
                self.response_client(message_decoded[0], curr_time, f"{price} @ {time_diff}")
            else:
                connection = sqlite3.connect("clients.db")
                cursor = connection.cursor()
                cursor.execute("INSERT INTO clients_log VALUES (?,?,?,?)", (client_id, curr_time, None, None))
                connection.commit()
                connection.close()
                print(f"client: {client_id} ({message_decoded[0]}) at {curr_time} get IN")
                self.response_client(message_decoded[0], curr_time)
        else:
            print(f"client_address_ip: {message_decoded[0]} at {curr_time} was NOT FOUND in database!")
            self.response_client(message_decoded[0], curr_time, "Sorry, you are not registered!")

    def export_to_csv(self):
        connection = sqlite3.connect("clients.db")
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM clients_log JOIN clients USING(id)")
        log_entries = cursor.fetchall()

        with open('clients_file.csv', mode='w') as csv_file:
            fieldnames = ['ip', 'in_time', 'out_time', 'price']
            writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

            writer.writeheader()
            for log_entry in log_entries:
                writer.writerow(
                    {'ip': log_entry[4], 'in_time': log_entry[1], 'out_time': log_entry[2], 'price': log_entry[3]})

        connection.commit()
        connection.close()
        self.export_ready.emit()

#!/usr/bin/env python3
import time

import paho.mqtt.client as mqtt
import tkinter
import sys
import socket

# The terminal ID - can be any string.
terminal_id = "T0"
# The broker name or IP address.
broker = sys.argv[1]
name = sys.argv[2]
# broker = "localhost"

# The MQTT client.
client = mqtt.Client()

# The main window with buttons to simulate the RFID card usage.
window = tkinter.Tk()

list_of_topics = list()


def process_message(client, userdata, message):
    # Decode message.
    message_decoded = (str(message.payload.decode("utf-8"))).split(",")

    if len(message_decoded) == 3:
        print(time.ctime() + ", " +
              message_decoded[0] + ", price: " + message_decoded[1] + ", time: " + message_decoded[2])
        client.unsubscribe("client/response/{0}".format(message_decoded[0]))
    else:
        print(time.ctime() + ", " +
              message_decoded[0] + ", " + message_decoded[1])


def call_server(client_name):
    client.subscribe("client/response/{0}".format(client_name))
    client.publish("client/request/{0}".format(client_name), client_name, )


def create_main_window(ip):
    window.geometry("300x200")
    window.title("SENDER " + name)

    intro_label = tkinter.Label(window, text="Select employee:")
    intro_label.grid(row=0, columnspan=5)

    button_1 = tkinter.Button(window, text="Call",
                              command=lambda: call_server(ip))
    button_1.grid(row=1, column=0)
    button_stop = tkinter.Button(window, text="Stop", command=window.quit)
    button_stop.grid(row=4, columnspan=2)


def connect_to_broker():
    client.connect(broker)
    client.on_message = process_message
    client.loop_start()


def get_identifier():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    ip = s.getsockname()[0]
    s.close()
    return ip


def disconnect_from_broker():
    client.loop_stop()
    client.disconnect()


def run_sender():
    connect_to_broker()
    create_main_window(get_identifier())

    window.mainloop()

    disconnect_from_broker()


if __name__ == "__main__":
    run_sender()

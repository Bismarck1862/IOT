#!/usr/bin/env python3
import time

import paho.mqtt.client as mqtt
import tkinter
import sys

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
    message_decoded = (str(message.payload.decode("utf-8"))).split(".")

    # Print message to console.
    if message_decoded[0] != "Client connected" and message_decoded[0] != "Client disconnected":
        print(time.ctime() + ", " +
              message_decoded[0] + ", " + message_decoded[2])
        client.unsubscribe("client/response/{0}".format(message_decoded[0]))
    else:
        print(message_decoded[0] + " : " + message_decoded[1])


def call_server(client_name):
    client.subscribe("client/response/{0}".format(client_name))
    client.publish("client/request/{0}".format(client_name), client_name + "." + terminal_id, )


def create_main_window():
    window.geometry("300x200")
    window.title("SENDER" + name)

    intro_label = tkinter.Label(window, text="Select employee:")
    intro_label.grid(row=0, columnspan=5)

    button_1 = tkinter.Button(window, text="Employee 1",
                              command=lambda: call_server("Employee 1"))
    button_1.grid(row=1, column=0)
    button_2 = tkinter.Button(window, text="Employee 2",
                              command=lambda: call_server("Employee 2"))
    button_2.grid(row=2, column=0)
    button_3 = tkinter.Button(window, text="Employee 3",
                              command=lambda: call_server("Employee 3"))
    button_3.grid(row=3, column=0)
    button_4 = tkinter.Button(window, text="Employee 4",
                              command=lambda: call_server("Employee 4"))
    button_4.grid(row=1, column=1)
    button_5 = tkinter.Button(window, text="Employee 5",
                              command=lambda: call_server("Employee 5"))
    button_5.grid(row=2, column=1)
    button_6 = tkinter.Button(window, text="Employee 6",
                              command=lambda: call_server("Employee 6"))
    button_6.grid(row=3, column=1)
    button_stop = tkinter.Button(window, text="Stop", command=window.quit)
    button_stop.grid(row=4, columnspan=2)


def connect_to_broker():
    client.connect(broker)
    client.on_message = process_message
    client.loop_start()


def disconnect_from_broker():
    client.loop_stop()
    client.disconnect()


def run_sender():
    connect_to_broker()
    create_main_window()

    window.mainloop()

    disconnect_from_broker()


if __name__ == "__main__":
    run_sender()

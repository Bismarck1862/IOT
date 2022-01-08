#!/usr/bin/env python3
import time

import paho.mqtt.client as mqtt
import tkinter
import sys

# The terminal ID - can be any string.
terminal_id = "T0"
# The broker name or IP address.
broker = sys.argv[1]
# broker = "localhost"

# The MQTT client.
client = mqtt.Client()

# The main window with buttons to simulate the RFID card usage.
window = tkinter.Tk()


def process_message(client, userdata, message):
    # Decode message.
    message_decoded = (str(message.payload.decode("utf-8"))).split(".")

    # Print message to console.
    if message_decoded[0] != "Client connected" and message_decoded[0] != "Client disconnected":
        print(time.ctime() + ", " +
              message_decoded[0] + ", " + message_decoded[2])
    else:
        print(message_decoded[0] + " : " + message_decoded[1])


def call_worker(worker_name):
    client.publish("client/name", worker_name + "." + terminal_id,)


def create_main_window():
    window.geometry("300x200")
    window.title("SENDER")

    intro_label = tkinter.Label(window, text="Select employee:")
    intro_label.grid(row=0, columnspan=5)

    button_1 = tkinter.Button(window, text="Employee 1",
                              command=lambda: call_worker("Employee 1"))
    button_1.grid(row=1, column=0)
    button_2 = tkinter.Button(window, text="Employee 2",
                              command=lambda: call_worker("Employee 2"))
    button_2.grid(row=2, column=0)
    button_3 = tkinter.Button(window, text="Employee 3",
                              command=lambda: call_worker("Employee 3"))
    button_3.grid(row=3, column=0)
    button_4 = tkinter.Button(window, text="Employee 4",
                              command=lambda: call_worker("Employee 4"))
    button_4.grid(row=1, column=1)
    button_5 = tkinter.Button(window, text="Employee 5",
                              command=lambda: call_worker("Employee 5"))
    button_5.grid(row=2, column=1)
    button_6 = tkinter.Button(window, text="Employee 6",
                              command=lambda: call_worker("Employee 6"))
    button_6.grid(row=3, column=1)
    button_stop = tkinter.Button(window, text="Stop", command=window.quit)
    button_stop.grid(row=4, columnspan=2)


def connect_to_broker():
    # Connect to the broker.
    client.connect(broker)
    # Send message about conenction.
    call_worker("Client connected")
    #
    # Starts client and subscribe.
    client.on_message = process_message
    client.loop_start()
    client.subscribe("client/response")


def disconnect_from_broker():
    # Send message about disconenction.
    call_worker("Client disconnected")
    client.loop_stop()
    # Disconnet the client.
    client.disconnect()


def run_sender():
    connect_to_broker()
    create_main_window()

    # Start to display window (It will stay here until window is displayed)
    window.mainloop()

    disconnect_from_broker()


if __name__ == "__main__":
    run_sender()

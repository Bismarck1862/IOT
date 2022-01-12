#!/usr/bin/env python3

import paho.mqtt.client as mqtt
import tkinter
import sys
import socket

broker = sys.argv[1]
name = sys.argv[2]

client = mqtt.Client()
client_ip = ''

window = tkinter.Tk()

def run_sender():
    connect_to_broker()
    client_ip = get_client_address_ip()
    create_main_window(client_ip)

    window.mainloop()

    disconnect_from_broker()


def connect_to_broker():
    client.connect(broker)
    client.on_message = process_message
    client.loop_start()


def get_client_address_ip():
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    return ip


def disconnect_from_broker():
    client.loop_stop()
    client.disconnect()


def process_message(client, _, message):
    message_decoded = (str(message.payload.decode("utf-8"))).split("@")

    print(message_decoded)

    if len(message_decoded) == 1:
        print(f"timestamp: {message_decoded[0]}")
    elif len(message_decoded) == 2:
        print(f"timestamp: {message_decoded[0]} | error_msg: {message_decoded[1]}")
    elif len(message_decoded) == 3:
        print(f"timestamp: {message_decoded[0]} | price: {message_decoded[1]} | time: {message_decoded[2]}")
        client.unsubscribe(f"client/response/{client_ip}")
    else:
        print(">>> Unsupported format of response message!")


def call_server(client_address_ip):
    client.subscribe(f"client/response/{client_address_ip}")
    client.publish(f"client/request/{client_address_ip}", client_address_ip)


def create_main_window(client_address_ip):
    window.geometry("300x200")
    window.title("SENDER " + name)

    intro_label = tkinter.Label(window, text="Select employee:")
    intro_label.grid(row=0, columnspan=5)

    button_1 = tkinter.Button(window, text="Call",
                              command=lambda: call_server(client_address_ip))
    button_1.grid(row=1, column=0)
    button_stop = tkinter.Button(window, text="Stop", command=window.quit)
    button_stop.grid(row=4, columnspan=2)


if __name__ == "__main__":
    run_sender()

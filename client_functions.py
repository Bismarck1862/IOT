import paho.mqtt.client as mqtt
import socket
from PySide2.QtCore import QObject, Signal

QOS = 2


def get_client_address_ip():
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    return ip


class Client(QObject):
    entry = Signal(str)
    error = Signal()
    exit = Signal(str, str, str)

    client = mqtt.Client()
    client_ip = get_client_address_ip()

    def __init__(self, broker, name, parent=None):
        super().__init__(parent)
        self.broker = broker
        self.name = name

    def process_message(self, client, _, message):
        message_decoded = (str(message.payload.decode("utf-8"))).split("@")
        if len(message_decoded) == 1:
            self.entry.emit(message_decoded[0])
        elif len(message_decoded) == 2:
            self.error.emit()
        elif len(message_decoded) == 3:
            self.exit.emit(message_decoded[0], message_decoded[1], message_decoded[2])
            client.unsubscribe(f"client/response/{self.client_ip}")
        else:
            print(">>> Unsupported format of response message!")

    def connect_to_broker(self):
        self.client.connect(self.broker)
        self.client.on_message = self.process_message
        self.client.loop_start()

    def disconnect_from_broker(self):
        self.client.loop_stop()
        self.client.disconnect()

    def call_server(self):
        self.client.subscribe(f"client/response/{self.client_ip}")
        self.client.publish(f"client/request/{self.client_ip}", self.client_ip, QOS)

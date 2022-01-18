import sqlite3
from PySide2.QtCore import QObject, Signal

class IpRegister(QObject):
    register_ready = Signal()
    register_delete_ready = Signal()

    def __init__(self, parent=None):
        super(IpRegister, self).__init__(parent)

    def register_client(self, client_ip):
        connection = sqlite3.connect("clients.db")
        cursor = connection.cursor()
        cursor.execute("INSERT INTO clients VALUES (?, ?)", (None, client_ip))
        cursor.execute("INSERT INTO registered_clients VALUES (?, ?)", (None, client_ip))
        connection.commit()
        connection.close()
        print(f"Client: {client_ip} was registered")
        self.register_ready.emit()

    def unregister_client(self, client_ip):
        connection = sqlite3.connect("clients.db")
        cursor = connection.cursor()
        cursor.execute("DELETE FROM registered_clients WHERE ip_address = '" + client_ip + "'")
        connection.commit()
        connection.close()
        print(f"Client {client_ip} was unregistered")
        self.register_delete_ready.emit()

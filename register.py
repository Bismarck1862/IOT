import sqlite3
from PySide2.QtCore import QObject, Signal



class IpRegister(QObject):
    register_ready = Signal()

    def __init__(self, parent=None):
        super(IpRegister, self).__init__(parent)

    def register_client(self, client_ip):
        print(client_ip)
        connection = sqlite3.connect("clients.db")
        cursor = connection.cursor()
        cursor.execute("INSERT INTO clients VALUES (?, ?)", (None, client_ip))
        connection.commit()
        connection.close()
        self.register_ready.emit()

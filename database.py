import sqlite3
import os
from PySide2.QtCore import QObject, Signal


def display_data():
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()

    for row in cursor.execute('SELECT * FROM clients'):
        print(row)

    for row in cursor.execute('SELECT * FROM clients_log'):
        print(row)

    connection.commit()
    connection.close()


def create_database():
    if os.path.exists("clients.db"):
        os.remove("clients.db")
        print("An old database removed.")
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    cursor.execute(""" CREATE TABLE clients_log (
            id INTEGER,
            in_time text,
            out_time text,
            price text
        )""")

    cursor.execute(""" CREATE TABLE clients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ip_address varchar(20) NOT NULL
        )""")

    cursor.execute(""" CREATE TABLE registered_clients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ip_address varchar(20) NOT NULL
        )""")
    
    connection.commit()
    connection.close()


class Database(QObject):
    clear_ready = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)

    def create_database(self):
        create_database()
        self.clear_ready.emit()


if __name__ == "__main__":
    create_database()
    display_data()

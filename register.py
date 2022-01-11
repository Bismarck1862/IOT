import sqlite3
import sys


def register_client(client_ip):
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    cursor.execute("INSERT INTO clients VALUES (?, ?)", (None, client_ip))
    connection.commit()
    connection.close()


if __name__ == "__main__":
    register_client(sys.argv[1])
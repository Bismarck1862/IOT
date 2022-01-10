import sqlite3
import os


def create_database():
    if os.path.exists("clients.db"):
        os.remove("clients.db")
        print("An old database removed.")
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()
    cursor.execute(""" CREATE TABLE clients_log (
        client text,
        in_time text,
        out_time text,
        price text
    )""")

    cursor.execute(""" CREATE TABLE clients (
        id INTEGER PRIMARY KEY,
        ip_address varchar(20) NOT NULL
    )""")
    connection.commit()
    connection.close()

    print("The new database created.")


def display_data():
    connection = sqlite3.connect("clients.db")
    cursor = connection.cursor()

    for row in cursor.execute('SELECT * FROM clients'):
        print(row)

    for row in cursor.execute('SELECT * FROM clients_log'):
        print(row)

    connection.commit()
    connection.close()


if __name__ == "__main__":
    create_database()
    display_data()

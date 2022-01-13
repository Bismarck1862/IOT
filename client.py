#!/usr/bin/env python3
import sys
import os
from client_connector import ClientConnector

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine

broker = sys.argv[1]
name = sys.argv[2]


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    client_connector = ClientConnector(broker, name)
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("clientConnector", client_connector)
    engine.load(os.path.join(os.path.dirname(__file__), "QML/MainClient.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())

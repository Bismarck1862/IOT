import sys
import os

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from server_connector import ServerConnector

broker = sys.argv[1]

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    server_connector = ServerConnector(broker)
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("serverConnector", server_connector)
    engine.load(os.path.join(os.path.dirname(__file__), "QML/MainServer.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

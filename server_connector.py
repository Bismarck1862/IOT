# This Python file uses the following encoding: utf-8
from logs_model import LogsModel
from PySide2.QtCore import QObject, Slot, Signal
from PySide2 import QtCore
import server_functions as server
from register import IpRegister
from server_functions import Server
from database import Database

class ServerConnector(QObject):

    showRegisterDialog = Signal()
    showDeleteDialog = Signal()
    showClearDialog = Signal()
    showExportDialog = Signal()

    def __init__(self, broker, parent=None):
        super(ServerConnector, self).__init__(parent)
        self.logs = []
        self._model = LogsModel(self.logs)
        self.register = IpRegister()
        self.server_obj = Server(broker)
        self.database = Database()
        self.server_obj.connect_to_broker()

        self.register.register_ready.connect(self.showRegisterDialog)
        self.server_obj.export_ready.connect(self.showExportDialog)
        self.database.clear_ready.connect(self.showClearDialog)

    def model(self):
        return self._model

    @Slot()
    def reload_list(self):
        self._model.setNewList(server.get_log())

    @Slot()
    def on_close(self):
        self.server_obj.disconnect_from_broker()

    @Slot(str)
    def on_register_ip(self, ip):
        self.register.register_client(ip)

    @Slot()
    def on_export(self):
        self.server_obj.export_to_csv()

    @Slot()
    def on_database_clear(self):
        self.database.create_database()

    def accept_register(self):
        self.showRegisterDialog.emit()

    model = QtCore.Property(QtCore.QObject, fget=model, constant=True)

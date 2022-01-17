# This Python file uses the following encoding: utf-8

from PySide2.QtCore import QObject, Slot, Signal
import PySide2.QtTest as Timer
from client_functions import Client


class ClientConnector(QObject):
    enableRegister = Signal()
    enableEntry = Signal()
    enableExit = Signal()
    enableError = Signal()
    countTimeEntry = Signal(str)
    countTimeExit = Signal(str, str)
    countTimeError = Signal()

    def __init__(self, broker, name, parent=None):
        super(ClientConnector, self).__init__(parent)
        self.client = Client(broker, name)
        self.client.connect_to_broker()
        self.client.entry.connect(lambda entry: self.show_entry(entry))
        self.client.exit.connect(lambda entry, price, time: self.show_exit(price, time))
        self.client.error.connect(self.show_error)

    @Slot()
    def on_close(self):
        self.client.disconnect_from_broker()

    @Slot()
    def on_register_clicked(self):
        print()

    def show_entry(self, time_entry):
        self.enableEntry.emit()
        self.countTimeEntry.emit(time_entry)

    def show_exit(self, price, time):
        self.enableExit.emit()
        self.countTimeExit.emit(price, time)

    def show_error(self):
        self.enableError.emit()
        self.countTimeError.emit()

    @Slot()
    def on_register_finished(self):
        self.client.call_server()

    @Slot()
    def on_timer_finished(self):
        self.enableRegister.emit()


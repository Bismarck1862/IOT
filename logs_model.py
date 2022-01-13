from PySide2 import QtCore

class LogsModel(QtCore.QAbstractListModel):

    NameRole = QtCore.Qt.UserRole + 1
    EntryTimeRole = QtCore.Qt.UserRole + 2
    ExitTimeRole = QtCore.Qt.UserRole + 3
    PriceRole = QtCore.Qt.UserRole + 4

    def __init__(self, logs=None, parent=None):
        super(LogsModel, self).__init__(parent)
        if logs is None:
            logs = []
        self._logs = logs

    def data(self, index, role=QtCore.Qt.DisplayRole):
        if 0 <= index.row() < self.rowCount() and index.isValid():
            item = self._logs[index.row()]
        if role == LogsModel.NameRole:
            return item[0]
        if role == LogsModel.EntryTimeRole:
            return item[1]
        if role == LogsModel.ExitTimeRole:
            return item[2]
        if role == LogsModel.PriceRole:
            return item[3]

    def rowCount(self, parent=QtCore.QModelIndex()):
        if parent.isValid():
            return 0
        return len(self._logs)

    def roleNames(self):
        roles = {LogsModel.NameRole: b"name",
                 LogsModel.EntryTimeRole: b"tentry",
                 LogsModel.ExitTimeRole: b"texit",
                 LogsModel.PriceRole: b"price"}
        return roles

    def setData(self, index, value, role=QtCore.Qt.DisplayRole):
        if role == QtCore.Qt.DisplayRole or role == QtCore.Qt.EditRole:
            if index.row() < 0 or index.row() >= len(self._logs):
                return False

            self._logs[index.row()] = value
            self.dataChanged.emit(index, index, [QtCore.Qt.EditRole | QtCore.Qt.DisplayRole])
            return True
        return False

    def setNewList(self, newList):
        self.beginResetModel()
        self._logs = newList
        self.endResetModel()

#    def insertRow(self, elem, index: PySide2.QtCore.QModelIndex=PySide2.QtCore.QModelIndex()):
#        self.beginInsertRows(index, 0, 0)
#        self._logs.insert(0, elem)
#        self.endInsertRows()

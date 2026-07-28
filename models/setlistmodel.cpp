#include "setlistmodel.h"

int SetListModel::rowCount(const QModelIndex&) const {
    return m_data.size();
}

QVariant SetListModel::data(const QModelIndex& index, int role) const {
    const auto& h = m_data[index.row()];
    if (role == IdRole) return h.id;
    if (role == NameRole) return h.name;
    return {};
}

Q_INVOKABLE void SetListModel::reload() {
    beginResetModel();
    m_data = repo.getAll();
    endResetModel();
}

Q_INVOKABLE void SetListModel::add(QString name) {
    int id = repo.create(name);
    beginInsertRows({}, m_data.size(), m_data.size());
    m_data.append({id,name});
    endInsertRows();
}

Q_INVOKABLE void SetListModel::removeRow(int row) {
    repo.remove(m_data[row].id);
    beginRemoveRows({},row,row);
    m_data.removeAt(row);
    endRemoveRows();
}
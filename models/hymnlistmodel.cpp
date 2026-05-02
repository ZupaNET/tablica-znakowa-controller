#include "hymnlistmodel.h"

int HymnListModel::rowCount(const QModelIndex&) const {
    return m_data.size();
}

QVariant HymnListModel::data(const QModelIndex& index, int role) const {
    const auto& h = m_data[index.row()];
    if (role == IdRole) return h.id;
    if (role == NameRole) return h.name;
    if (role == CategoryRole) return h.categoryId;
    return {};
}

Q_INVOKABLE void HymnListModel::reload() {
    beginResetModel();
    m_data = repo.getAll();
    endResetModel();
}

Q_INVOKABLE void HymnListModel::add(QString name, int categoryId) {
    int id = repo.create(name, categoryId);
    beginInsertRows({}, m_data.size(), m_data.size());
    m_data.append({id,name,categoryId});
    endInsertRows();
}

Q_INVOKABLE void HymnListModel::removeRow(int row) {
    repo.remove(m_data[row].id);
    beginRemoveRows({},row,row);
    m_data.removeAt(row);
    endRemoveRows();
}

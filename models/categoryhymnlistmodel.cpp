#include "categoryhymnlistmodel.h"

void CategoryHymnListModel::setCategoryId(int id) {
    if (m_categoryId == id) return;
    m_categoryId = id;
    emit categoryIdChanged();
    reload();
}

int CategoryHymnListModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_data.size();
}

QVariant CategoryHymnListModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_data.size())
        return {};

    const Hymn &h = m_data[index.row()];

    switch (role) {
    case IdRole: return h.id;
    case NameRole: return h.name;
    case CategoryRole: return h.categoryId;
    default: return {};
    }
}

Q_INVOKABLE void CategoryHymnListModel::reload() {
    if (m_categoryId < 0) return;

    beginResetModel();
    m_data = repo.getHymns(m_categoryId);
    endResetModel();
}
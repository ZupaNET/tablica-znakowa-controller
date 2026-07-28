#include "sethymnlistmodel.h"

void SetHymnListModel::setSetId(int id) {
    if (m_setId == id) return;
    m_setId = id;
    emit setIdChanged();
    reload();
}

int SetHymnListModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_data.size();
}

QVariant SetHymnListModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_data.size())
        return {};

    const Hymn &h = m_data[index.row()];

    switch (role) {
    case IdRole: return h.id;
    case NameRole: return h.name;
    case CategoryRole: return h.categoryId;
    case ShownScreensRole: return h.shownScreens;
    default: return {};
    }
}

Q_INVOKABLE void SetHymnListModel::reload() {
    if (m_setId < 0) return;

    beginResetModel();
    m_data = repo.getHymns(m_setId);
    endResetModel();
}

Q_INVOKABLE void SetHymnListModel::addHymn(int hymnId) {
    repo.addHymn(m_setId, hymnId);
    reload();
}

Q_INVOKABLE void SetHymnListModel::removeHymn(int row) {
    if (row < 0 || row >= m_data.size()) return;

    repo.removeHymn(m_setId, m_data[row].id);
    reload();
}

Q_INVOKABLE void SetHymnListModel::move(int from, int to) {
    if (from < 0 || to < 0 || from >= m_data.size() || to >= m_data.size())
        return;

    beginMoveRows(QModelIndex(), from, from,
                  QModelIndex(), (from < to ? to + 1 : to));

    m_data.move(from, to);

    endMoveRows();
}

Q_INVOKABLE void SetHymnListModel::saveOrder() {
    QList<int> ids;

    for (const auto &h : m_data)
        ids.append(h.id);

    repo.reorder(m_setId, ids);
}

Q_INVOKABLE void SetHymnListModel::saveShownScreens() {
    for (const auto &h : m_data){
        repo.changeShownScreens(m_setId, h.id, h.shownScreens);
    }
}
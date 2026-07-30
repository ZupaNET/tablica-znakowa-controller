#include "sethymnmodel.h"

QVariant SetHymnModel::data(const QModelIndex& index, int role) const
{
    const Hymn& item =
        m_data[index.row()];

    switch(role)
    {
    case IdRole:
        return item.id;

    case NameRole:
        return item.name;

    case CategoryRole:
        return item.categoryId;

    case ShownScreensRole:
        return item.shownScreens;
    }

    return {};
}

QHash<int,QByteArray> SetHymnModel::roleNames() const
{
    return HymnRoles::roleNames();
}

void SetHymnModel::reload()
{
    if(parentId() < 0) updateData(QList<Hymn>());
    else updateData(fetch(parentId()));
}

QList<Hymn> SetHymnModel::fetch(int id)
{
    return repo.getHymns(id);
}

Q_INVOKABLE void SetHymnModel::addHymn(int hymnId) {
    repo.addHymn(m_parentId, hymnId);
    reload();
}

Q_INVOKABLE void SetHymnModel::removeHymn(int row) {
    if (row < 0 || row >= m_data.size()) return;

    repo.removeHymn(m_parentId, m_data[row].id);
    reload();
}

Q_INVOKABLE void SetHymnModel::move(int from, int to) {
    if (from < 0 || to < 0 || from >= m_data.size() || to >= m_data.size())
        return;

    beginMoveRows(QModelIndex(), from, from,
                  QModelIndex(), (from < to ? to + 1 : to));

    m_data.move(from, to);

    endMoveRows();
}

Q_INVOKABLE void SetHymnModel::saveOrder() {
    QList<int> ids;

    foreach (const auto &h, m_data) {
        ids.append(h.id);
    }

    repo.reorder(m_parentId, ids);
}

void SetHymnModel::updateShownScreens(int row, QVariantList screens)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto& hymn = m_data[row];

    hymn.shownScreens = screens;

    repo.changeShownScreens(
        m_parentId,
        hymn.id,
        hymn.shownScreens
        );

    emit dataChanged(
        index(row),
        index(row),
        {ShownScreensRole}
        );
}
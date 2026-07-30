#include "screenmodel.h"

int ScreenModel::hymnId() const
{
    return m_hymnId;
}

void ScreenModel::setHymnId(int id) {
    if (m_hymnId == id) return;
    m_hymnId = id;
    emit hymnIdChanged();
    reload();
}

QVariant ScreenModel::data(const QModelIndex& index,int role) const
{
    if(!index.isValid())
        return {};


    const Screen& item = m_data[index.row()];


    switch(role)
    {
    case IdRole:
        return item.id;

    case ScreenRole:
        return QVariant::fromValue(item);

    case HymnNameRole:
        return item.hymnName;

    case TextRole:
        return item.text;

    case OrderRole:
        return item.order;

    case FontRole:
        return item.font;

    case ExcerptRole:
        QStringList lines = item.text.split('\n');

        for (const auto& line : std::as_const(lines))
        {
            if (!line.trimmed().isEmpty())
                return line.trimmed();
        }

        return "";

    }


    return {};
}

QHash<int,QByteArray> ScreenModel::roleNames() const
{
    return ScreenRoles::roleNames();
}

void ScreenModel::reload()
{
    if(m_hymnId < 0) updateData(QList<Screen>());
    else updateData(repo.getByHymn(m_hymnId));
}

Q_INVOKABLE void ScreenModel::add(QString text, int font) {
    repo.create(m_hymnId,text,font);
    reload();
}

void ScreenModel::update(int row, const QString& text, int font)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto& s = m_data[row];

    if (!text.isNull())
        s.text = text;

    if (font >= 0)
        s.font = font;

    repo.update(s.id, s.text, s.font);

    QModelIndex idx = index(row);

    emit dataChanged(
        idx,
        idx,
        {
            TextRole,
            FontRole
        }
        );
}

void ScreenModel::duplicate(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto& s = m_data[row];

    repo.create(m_hymnId, s.text, s.font);
    reload();
}

Q_INVOKABLE void ScreenModel::removeRow(int row) {
    repo.remove(m_data[row].id);
    reload();
}

Q_INVOKABLE void ScreenModel::move(int from, int to) {
    beginMoveRows({},from,from,{},(from<to?to+1:to));
    m_data.move(from,to);
    endMoveRows();
}

Q_INVOKABLE void ScreenModel::saveOrder() {
    QList<int> ids;
    for (auto& s: m_data) ids.append(s.id);
    repo.reorder(m_hymnId,ids);
}

Q_INVOKABLE Screen ScreenModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}
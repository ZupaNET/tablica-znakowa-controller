#include "setscreenmodel.h"

int SetScreenModel::setId() const
{
    return m_setId;
}

void SetScreenModel::setSetId(int id)
{
    if (m_setId == id)
        return;

    m_setId = id;
    emit setIdChanged();

    reload();
}


int SetScreenModel::hymnId() const
{
    return m_hymnId;
}

void SetScreenModel::setHymnId(int id)
{
    if (m_hymnId == id)
        return;

    m_hymnId = id;
    emit hymnIdChanged();

    reload();
}

QVariant SetScreenModel::data(const QModelIndex& index,int role) const
{
    if (!index.isValid())
        return {};

    const Screen& item = m_data[index.row()];

    switch(role)
    {
    case IdRole:
        return item.id;

    case ScreenRole:
        return QVariant::fromValue(item);

    case HymnIdRole:
        return item.hymnId;

    case HymnNameRole:
        return item.hymnName;

    case TextRole:
        return item.text;

    case OrderRole:
        return item.order;

    case FontRole:
        return item.font;

    case ShownRole:
        return item.shown;

    case ExcerptRole:
    {
        QStringList lines = item.text.split('\n');

        for (const auto& line : std::as_const(lines))
        {
            QString trimmed = line.trimmed();

            if (trimmed.length() >= 4)
                return trimmed;
        }

        return "";
    }

    }

    return {};
}

QHash<int,QByteArray> SetScreenModel::roleNames() const
{
    return ScreenRoles::roleNames();
}


void SetScreenModel::reload()
{
    if(m_setId < 0 || m_hymnId < 0)
    {
        updateData({});
        return;
    }

    updateData(repo.getScreens(m_setId, m_hymnId));
}

void SetScreenModel::changeScreenVisibility(int row, bool shown)
{
    if(m_setId < 0)
        return;

    repo.changeScreenVisibility(m_setId, get(row).id, shown);

    reload();
}

void SetScreenModel::changeAllScreenVisibility(bool shown)
{
    if(m_setId < 0 || m_hymnId < 0)
        return;

    repo.changeScreenVisibilityByHymn(m_setId, m_hymnId, shown);

    reload();
}

Screen SetScreenModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}
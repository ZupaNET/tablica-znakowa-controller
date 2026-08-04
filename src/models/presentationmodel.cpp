#include "presentationmodel.h"

void PresentationModel::setSetId(int id) {
    if (m_setId == id) return;
    m_setId = id;
    emit setIdChanged();
    reload();
}

void PresentationModel::setShowAll(bool show)
{
    if(m_showAll == show) return;
    m_showAll = show;
    emit showAllChanged();
    reload();
}

void PresentationModel::setHymnMode(bool enable)
{
    if(m_hymnMode == enable) return;
    m_hymnMode = enable;
    emit hymnModeChanged();
    reload();
}

QVariant PresentationModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_data.size())
    {
        return {};
    }

    auto& s = m_data[index.row()];
    if (role==IdRole) return s.id;
    if (role==ScreenRole) return QVariant::fromValue(s);
    if (role==TextRole) return s.text;
    if (role==OrderRole) return s.order;
    if (role==FontRole) return s.font;
    if (role==HymnNameRole) return s.hymnName;
    if (role==ShownRole) return s.shown;
    if (role==ExcerptRole){
        QStringList lines = s.text.split('\n');

        for (const auto& line : std::as_const(lines))
        {
            if (!line.trimmed().isEmpty())
                return line.trimmed();
        }

        return "";
    }

    return {};
}

QHash<int,QByteArray> PresentationModel::roleNames() const
{
    return ScreenRoles::roleNames();
}

void PresentationModel::update(int row, const QString& text, int font)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto& s = m_data[row];

    if (!text.isNull())
        s.text = text;

    if (font >= 0)
        s.font = font;

    screenRepo.update(s.id, s.text, s.font);

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

void PresentationModel::changeScreenVisibility(int row, bool shown)
{
    if(m_setId < 0 || m_hymnMode)
        return;

    if (row < 0 || row >= m_data.size())
        return;

    Screen screen = m_data[row];

    if (screen.shown == shown)
        return;

    setRepo.changeScreenVisibility(m_setId, screen.id, shown);

    if (!shown)
    {
        beginRemoveRows({}, row, row);

        m_data.removeAt(row);

        endRemoveRows();

        return;
    }

    const QList<Screen> allScreens = service.build(m_setId, true);

    Screen restored;
    bool found = false;

    int insertRow = 0;

    for (const Screen &s : allScreens)
    {
        if (s.id == screen.id)
        {
            restored = s;
            restored.shown = true;
            found = true;
            break;
        }

        if (s.shown)
            ++insertRow;
    }

    if (!found)
        return;

    beginInsertRows({}, insertRow, insertRow);

    m_data.insert(insertRow, restored);

    endInsertRows();

}

Q_INVOKABLE void PresentationModel::reload() {
    if (m_setId < 0) return;

    if(!m_hymnMode)
        updateData(service.build(m_setId, m_showAll));
    else
    {
        QList<Screen> list;
        auto emptyScreen = Screen{
            -1,
            -1,
            tr("Pusty"),
            "",
            -1,
            0,
            true
        };
        list.append(screenRepo.getByHymn(m_setId));
        list.append(emptyScreen);
        updateData(list);
    }
}

Q_INVOKABLE Screen PresentationModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}

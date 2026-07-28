#include "presentationmodel.h"

void PresentationModel::setSetId(int id) {
    if (m_setId == id) return;
    m_setId = id;
    emit setIdChanged();
    reload();
}

QVariant PresentationModel::data(const QModelIndex& index, int role) const {
    auto& s = m_data[index.row()];
    if (role==IdRole) return s.id;
    if (role==ScreenRole) return QVariant::fromValue(s);
    if (role==TextRole) return s.text;
    if (role==OrderRole) return s.order;
    if (role==FontRole) return s.font;
    if (role==HymnNameRole) return s.hymnName;
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

Q_INVOKABLE void PresentationModel::reload() {
    if (m_setId < 0) return;
    beginResetModel();
    m_data.clear();

    QList<Hymn> hymns = setRepo.getHymns(m_setId);
    m_data.append({-1, -1, "Pusty", "", -1, 0});
    foreach (const Hymn &h, hymns) {
        QList<Screen> screens = screenRepo.getByHymn(h.id);
        foreach (const Screen &s, screens){
            if (h.shownScreens.contains(s.order)){
                m_data.append(s);
            }
        }
        m_data.append({-1, -1, "Pusty", "", -1, 0});
    }
    endResetModel();
}

Q_INVOKABLE Screen PresentationModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}

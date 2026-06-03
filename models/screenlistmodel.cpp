#include "screenlistmodel.h"

void ScreenListModel::setHymnId(int id) {
    if (m_hymnId == id) return;
    m_hymnId = id;
    emit hymnIdChanged();
    reload();
}

QVariant ScreenListModel::data(const QModelIndex& index, int role) const {
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

Q_INVOKABLE void ScreenListModel::reload() {
    if (m_hymnId < 0) return;
    beginResetModel();
    m_data = repo.getByHymn(m_hymnId);
    endResetModel();
}

Q_INVOKABLE void ScreenListModel::add(QString text, int font) {
    repo.create(m_hymnId,text,font);
    reload();
}

Q_INVOKABLE void ScreenListModel::removeRow(int row) {
    repo.remove(m_data[row].id);
    reload();
}

Q_INVOKABLE void ScreenListModel::move(int from, int to) {
    beginMoveRows({},from,from,{},(from<to?to+1:to));
    m_data.move(from,to);
    endMoveRows();
}

Q_INVOKABLE void ScreenListModel::saveOrder() {
    QList<int> ids;
    for (auto& s: m_data) ids.append(s.id);
    repo.reorder(m_hymnId,ids);
}

Q_INVOKABLE Screen ScreenListModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}
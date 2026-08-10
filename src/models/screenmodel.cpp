// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "screenmodel.h"

int ScreenModel::hymnId() const
{
    return m_hymnId;
}

void ScreenModel::setHymnId(int id)
{
    if (m_hymnId == id) return;

    m_hymnId = id;
    emit hymnIdChanged();

    reload();
}

QVariant ScreenModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_data.size())
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
        return item.getExcerpt();
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

void ScreenModel::add(const QString& text, int font)
{
    Screen s = repo.create(m_hymnId, text, font);

    beginInsertRows({}, m_data.size(), m_data.size());

    m_data.append(Screen{
        s.id,
        m_hymnId,
        s.hymnName,
        text,
        s.order,
        font
    });

    endInsertRows();
}

void ScreenModel::update(int row, const QString& text, int font)
{
    if(row < 0 || row >= m_data.size())
        return;

    Screen& s = m_data[row];

    QString newText = s.text;
    int newFont = s.font;

    if (!text.isNull())
        newText = text;

    if (font >= 0)
        newFont = font;

    repo.update(s.id, newText, newFont);

    s.text = newText;
    s.font = newFont;

    QModelIndex idx = index(row);

    QVector<int> roles;

    if (!text.isNull())
        roles << TextRole;

    if (font >= 0)
        roles << FontRole;

    emit dataChanged(idx, idx, roles);;
}

void ScreenModel::duplicate(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto& s = m_data[row];

    Screen a = repo.create(m_hymnId, s.text, s.font);

    beginInsertRows({}, m_data.size(), m_data.size());

    m_data.append(Screen{
        a.id,
        m_hymnId,
        a.hymnName,
        a.text,
        a.order,
        a.font
    });

    endInsertRows();
}

void ScreenModel::removeRow(int row)
{
    beginRemoveRows({}, row, row);

    repo.remove(m_data[row].id);

    m_data.removeAt(row);

    endRemoveRows();
}

void ScreenModel::move(int from, int to)
{
    if (from == to ||
        from < 0 || from >= m_data.size() ||
        to   < 0 || to   >= m_data.size())
        return;

    beginMoveRows({}, from, from, {}, from < to ? to + 1 : to);
    m_data.move(from, to);
    endMoveRows();

    int movedId = m_data[to].id;
    repo.move(m_hymnId, movedId, from, to);
}

Q_INVOKABLE Screen ScreenModel::get(int index) const
{
    if(index < 0 || index >= m_data.size())
        return {};

    const Screen& s = m_data[index];

    return s;
}
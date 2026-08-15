// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "presentationmodel.h"

int PresentationModel::presentId() const
{
    return m_presentId;
}

void PresentationModel::setPresentId(int id) {
    if (m_presentId == id) return;

    m_presentId = id;
    emit presentIdChanged();

    reload();
}

void PresentationModel::setHymnMode(bool enable)
{
    if(m_hymnMode == enable) return;

    m_hymnMode = enable;
    emit hymnModeChanged();

    reload();
}

QVariant PresentationModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_data.size())
        return {};

    const Screen& s = m_data[index.row()];

    switch (role)
    {
    case IdRole:
        return s.id;

    case ScreenRole:
        return QVariant::fromValue(s);

    case TextRole:
        return s.text;

    case OrderRole:
        return s.order;

    case FontRole:
        return s.font;

    case HymnNameRole:
        return s.hymnName;

    case ShownRole:
        return s.shown;

    case ExcerptRole:
        return s.getExcerpt();

    default:
        return {};
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

    Screen& s = m_data[row];

    if (!text.isNull())
        s.text = text;

    if (font >= 0)
        s.font = font;

    screenRepo.update(s.id, s.text, s.font);

    QModelIndex idx = index(row);

    emit dataChanged(idx, idx, { TextRole, FontRole, ExcerptRole });
}

void PresentationModel::reload()
{
    if (m_presentId < 0) return;

    if(!m_hymnMode)
        updateData(service.build(m_presentId));
    else
    {
        QList<Screen> list;
        auto emptyScreen = Screen::emptyScreen();
        list.append(screenRepo.getByHymn(m_presentId));
        list.append(emptyScreen);
        updateData(list);
    }
}

Screen PresentationModel::get(int index) const
{
    if(index < 0 || index >= m_data.size())
        return {};

    const Screen& s = m_data[index];

    return s;
}

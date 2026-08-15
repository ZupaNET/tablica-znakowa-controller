// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef NATURALSORT_H
#define NATURALSORT_H

#include <QString>
#include <QCollator>
#include <QLocale>

namespace NaturalSort
{
    class Comparator
    {
    public:
        explicit Comparator(const QLocale &locale = QLocale());

        int compare(const QString &a, const QString &b) const;

    private:
        QCollator m_collator;
    };

    int compare(const QString &a, const QString &b, const QCollator &collator);
}

#endif // NATURALSORT_H

// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "naturalsort.h"

#include <QChar>

namespace NaturalSort
{

Comparator::Comparator(const QLocale &locale)
{
    m_collator.setLocale(locale);
    m_collator.setCaseSensitivity(Qt::CaseInsensitive);
    m_collator.setNumericMode(false);
}

int Comparator::compare(const QString &a, const QString &b) const
{
    int posA = 0;
    int posB = 0;

    while (posA < a.size() && posB < b.size()) {

        const QChar charA = a.at(posA);
        const QChar charB = b.at(posB);

        const bool numberA = charA.isDigit();
        const bool numberB = charB.isDigit();

        if (numberA && numberB) {

            const int startA = posA;
            const int startB = posB;

            while (posA < a.size() && a.at(posA).isDigit())
                ++posA;

            while (posB < b.size() && b.at(posB).isDigit())
                ++posB;

            int firstA = startA;
            int firstB = startB;

            while (firstA < posA - 1 &&
                   a.at(firstA) == QChar('0')) {
                ++firstA;
            }

            while (firstB < posB - 1 &&
                   b.at(firstB) == QChar('0')) {
                ++firstB;
            }

            const int lengthA = posA - firstA;
            const int lengthB = posB - firstB;

            if (lengthA != lengthB)
                return lengthA < lengthB ? -1 : 1;

            for (int k = 0; k < lengthA; ++k) {

                const QChar digitA = a.at(firstA + k);
                const QChar digitB = b.at(firstB + k);

                if (digitA != digitB)
                    return digitA < digitB ? -1 : 1;
            }

            continue;
        }

        if (numberA != numberB) {

            const QString textA(charA);
            const QString textB(charB);

            const int result = m_collator.compare(textA, textB);

            if (result != 0)
                return result < 0 ? -1 : 1;

            ++posA;
            ++posB;
            continue;
        }

        const int startA = posA;
        const int startB = posB;

        while (posA < a.size() && !a.at(posA).isDigit())
            ++posA;

        while (posB < b.size() && !b.at(posB).isDigit())
            ++posB;

        const QString textA = a.mid(startA, posA - startA);
        const QString textB = b.mid(startB, posB - startB);

        const int result = m_collator.compare(textA, textB);

        if (result != 0)
            return result < 0 ? -1 : 1;
    }

    if (posA < a.size())
        return 1;

    if (posB < b.size())
        return -1;

    return 0;
}

}
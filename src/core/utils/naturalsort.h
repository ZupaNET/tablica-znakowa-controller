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

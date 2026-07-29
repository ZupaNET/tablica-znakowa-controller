#ifndef HYMN_H
#define HYMN_H

#include <QObject>
#include <QtQml>
#include <QString>
#include <QVariantList>

struct Hymn {
    int id;
    QString name;
    int categoryId;
    QVariantList shownScreens;
};

#endif // HYMN_H

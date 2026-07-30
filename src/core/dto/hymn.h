#ifndef HYMN_H
#define HYMN_H

#include <QObject>
#include <QtQml>
#include <QString>
#include <QVariantList>

struct Hymn {
    Q_GADGET

    Q_PROPERTY(int hymnId MEMBER id)
    Q_PROPERTY(QString hymnName MEMBER name)
    Q_PROPERTY(int categoryId MEMBER categoryId)
    Q_PROPERTY(QVariantList shownScreens MEMBER shownScreens)

public:
    int id;
    QString name;
    int categoryId;
    QVariantList shownScreens;
};
Q_DECLARE_METATYPE(Hymn)

#endif // HYMN_H

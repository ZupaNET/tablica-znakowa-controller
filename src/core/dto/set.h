#ifndef SET_H
#define SET_H

#include <QObject>
#include <QtQml>
#include <QString>
#include <QVariantList>

struct Set {
    Q_GADGET

    Q_PROPERTY(int setId MEMBER id)
    Q_PROPERTY(QString setName MEMBER name)
    Q_PROPERTY(int order MEMBER order)

public:
    int id;
    QString name;
    int order;
};
Q_DECLARE_METATYPE(Set)

#endif // SET_H

#ifndef CATEGORY_H
#define CATEGORY_H

#include <QObject>
#include <QtQml>
#include <QString>
#include <QVariantList>

struct Category {
    Q_GADGET

    Q_PROPERTY(int categoryId MEMBER id)
    Q_PROPERTY(QString categoryName MEMBER name)

public:
    int id;
    QString name;
};
Q_DECLARE_METATYPE(Category);

#endif // CATEGORY_H

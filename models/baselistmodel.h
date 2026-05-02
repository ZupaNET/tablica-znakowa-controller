#ifndef BASELISTMODEL_H
#define BASELISTMODEL_H

#include <QAbstractListModel>

class BaseListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit BaseListModel(QObject *parent = nullptr)
        : QAbstractListModel(parent) {}

    Q_INVOKABLE virtual void reload() = 0;
};

#endif // BASELISTMODEL_H

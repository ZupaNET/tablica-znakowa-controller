#ifndef SETLISTMODEL_H
#define SETLISTMODEL_H

#include "baselistmodel.h"
#include "repositories/setrepository.h"

class SetListModel : public BaseListModel
{
    Q_OBJECT
public:
    enum Roles { IdRole=Qt::UserRole+1, NameRole};

    explicit SetListModel(QObject *parent = nullptr)
        : BaseListModel(parent) {}

    int rowCount(const QModelIndex&) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override {
        return {
            {IdRole,"id"},
            {NameRole,"name"}
        };
    }

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(QString name);
    Q_INVOKABLE void removeRow(int row);

private:
    QList<Set> m_data;
    SetRepository repo;
};

#endif // SETLISTMODEL_H

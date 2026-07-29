#ifndef SETHYMNMODEL_H
#define SETHYMNMODEL_H

#include "hymnrelationmodel.h"
#include "repositories/setrepository.h"

class SetHymnModel : public HymnRelationModel
{
    Q_OBJECT
    QML_ELEMENT

public:

    explicit SetHymnModel(QObject *parent = nullptr)
        : HymnRelationModel(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void addHymn(int hymnId);
    Q_INVOKABLE void removeHymn(int row);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void saveOrder();
    Q_INVOKABLE void saveShownScreens();

protected:

    QList<Hymn> fetch(int id) override;


private:

    SetRepository repo;
};

#endif // SETHYMNMODEL_H

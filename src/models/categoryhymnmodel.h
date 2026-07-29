#ifndef CATEGORYHYMNMODEL_H
#define CATEGORYHYMNMODEL_H

#include "hymnrelationmodel.h"
#include "repositories/categoryrepository.h"

class CategoryHymnModel : public HymnRelationModel
{
    Q_OBJECT
    QML_ELEMENT

public:

    explicit CategoryHymnModel(QObject *parent = nullptr)
        : HymnRelationModel(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;

protected:

    QList<Hymn> fetch(int id) override;


private:

    CategoryRepository repo;
};

#endif // CATEGORYHYMNMODEL_H

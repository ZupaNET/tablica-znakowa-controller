#ifndef CATEGORYHYMNLISTMODEL_H
#define CATEGORYHYMNLISTMODEL_H

#include "baselistmodel.h"
#include "repositories/categoryrepository.h"

class CategoryHymnListModel : public BaseListModel
{
    Q_OBJECT
    Q_PROPERTY(int categoryId READ categoryId WRITE setCategoryId NOTIFY categoryIdChanged)
public:
    enum Roles { IdRole=Qt::UserRole+1, NameRole, CategoryRole};

    explicit CategoryHymnListModel(QObject *parent = nullptr)
        : BaseListModel(parent) {}

    int categoryId() const { return m_categoryId; }
    void setCategoryId(int id);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override {
        return {
            {IdRole, "id"},
            {NameRole, "name"},
            {CategoryRole, "categoryId"}
        };
    }

    Q_INVOKABLE void reload() override;

signals:
    void categoryIdChanged();

private:
    int m_categoryId = -1;
    QList<Hymn> m_data;

    CategoryRepository repo;
};

#endif // CATEGORYHYMNLISTMODEL_H

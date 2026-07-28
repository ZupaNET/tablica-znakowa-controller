#ifndef SETHYMNLISTMODEL_H
#define SETHYMNLISTMODEL_H

#include "baselistmodel.h"
#include "repositories/setrepository.h"

class SetHymnListModel : public BaseListModel
{
    Q_OBJECT
    Q_PROPERTY(int setId READ setId WRITE setSetId NOTIFY setIdChanged)
public:
    enum Roles { IdRole=Qt::UserRole+1, NameRole, CategoryRole, ShownScreensRole };

    explicit SetHymnListModel(QObject *parent = nullptr)
        : BaseListModel(parent) {}

    int setId() const { return m_setId; }
    void setSetId(int id);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override {
        return {
            {IdRole, "id"},
            {NameRole, "name"},
            {CategoryRole, "categoryId"},
            {ShownScreensRole, "shownScreens"}
        };
    }

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void addHymn(int hymnId);
    Q_INVOKABLE void removeHymn(int row);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void saveOrder();
    Q_INVOKABLE void saveShownScreens();

signals:
    void setIdChanged();

private:
    int m_setId = -1;
    QList<Hymn> m_data;

    SetRepository repo;
};

#endif // SETHYMNLISTMODEL_H

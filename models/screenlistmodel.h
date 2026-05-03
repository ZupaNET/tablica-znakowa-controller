#ifndef SCREENLISTMODEL_H
#define SCREENLISTMODEL_H

#include "baselistmodel.h"
#include "repositories/screenrepository.h"

class ScreenListModel : public BaseListModel
{
    Q_OBJECT
    Q_PROPERTY(int hymnId READ hymnId WRITE setHymnId NOTIFY hymnIdChanged)
public:
    int hymnId() const { return m_hymnId; }

    void setHymnId(int id);

    enum Roles { IdRole=Qt::UserRole+1, TextRole, OrderRole, FontRole };

    explicit ScreenListModel(QObject *parent = nullptr)
        : BaseListModel(parent) {}

    int rowCount(const QModelIndex&) const override { return m_data.size(); }
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override {
        return {
            {IdRole,"id"},
            {TextRole,"text"},
            {OrderRole,"order"},
            {FontRole,"font"}
        };
    }

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(QString text, int font);
    Q_INVOKABLE void removeRow(int row);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void saveOrder();

signals:
    void hymnIdChanged();

private:
    int m_hymnId = -1;
    QList<Screen> m_data;
    ScreenRepository repo;
};

#endif // SCREENLISTMODEL_H

#ifndef PRESENTATIONMODEL_H
#define PRESENTATIONMODEL_H

#include "baselistmodel.h"
#include "repositories/screenrepository.h"
#include "repositories/setrepository.h"

class PresentationModel : public BaseListModel
{
    Q_OBJECT
    Q_PROPERTY(int setId READ setId WRITE setSetId NOTIFY setIdChanged)
public:
    int setId() const { return m_setId; }

    void setSetId(int id);

    enum Roles { IdRole=Qt::UserRole+1, ScreenRole, HymnNameRole, TextRole, OrderRole, FontRole, ExcerptRole };

    explicit PresentationModel(QObject *parent = nullptr)
        : BaseListModel(parent) {}

    int rowCount(const QModelIndex&) const override { return m_data.size(); }
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override {
        return {
            {IdRole,"id"},
            {ScreenRole,"screen"},
            {HymnNameRole,"hymnName"},
            {TextRole,"text"},
            {OrderRole,"order"},
            {FontRole,"font"},
            {ExcerptRole,"excerpt"}
        };
    }

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE Screen get(int index) const;

signals:
    void setIdChanged();

private:
    int m_setId = -1;
    QList<Screen> m_data;
    ScreenRepository screenRepo;
    SetRepository setRepo;
};
#endif // PRESENTATIONMODEL_H

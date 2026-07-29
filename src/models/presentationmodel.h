#ifndef PRESENTATIONMODEL_H
#define PRESENTATIONMODEL_H

#include "entitylistmodel.h"
#include "core/dto/screen.h"
#include "roles/screenroles.h"
#include "services/presentationservice.h"

class PresentationModel : public EntityListModel<Screen>, public ScreenRoles
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int setId READ setId WRITE setSetId NOTIFY setIdChanged)

public:

    explicit PresentationModel(QObject *parent = nullptr)
        : EntityListModel<Screen>(parent) {}

    int setId() const { return m_setId; }
    void setSetId(int id);

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE Screen get(int index) const;

signals:
    void setIdChanged();

private:
    int m_setId = -1;
    PresentationService service;
};
#endif // PRESENTATIONMODEL_H

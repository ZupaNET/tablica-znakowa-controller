// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef PRESENTATIONMODEL_H
#define PRESENTATIONMODEL_H

#include "entitylistmodel.h"
#include "core/dto/screen.h"
#include "roles/screenroles.h"
#include "services/presentationservice.h"
#include "repositories/screenrepository.h"
#include "repositories/setrepository.h"

class PresentationModel : public EntityListModel<Screen>, public ScreenRoles
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int presentId READ presentId WRITE setPresentId NOTIFY presentIdChanged)
    Q_PROPERTY(int hymnMode READ hymnMode WRITE setHymnMode NOTIFY hymnModeChanged)

public:

    explicit PresentationModel(QObject *parent = nullptr)
        : EntityListModel<Screen>(parent) {}

    int presentId() const;
    void setPresentId(int id);

    bool hymnMode() const { return m_hymnMode; }
    void setHymnMode(bool enable);

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void update(int row, const QString& text, int font);
    Q_INVOKABLE Screen get(int index) const;

signals:
    void presentIdChanged();
    void showAllChanged();
    void hymnModeChanged();

private:
    int m_presentId = -1;
    bool m_hymnMode = false;

    PresentationService service;
    ScreenRepository screenRepo;
    SetRepository setRepo;
};
#endif // PRESENTATIONMODEL_H

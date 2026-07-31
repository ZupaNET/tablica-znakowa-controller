#ifndef PRESENTATIONSERVICE_H
#define PRESENTATIONSERVICE_H

#include <QList>
#include "core/dto/screen.h"
#include "repositories/setrepository.h"

class PresentationService
{
public:

    QList<Screen> build(int setId);

private:
    SetRepository setRepo;
};

#endif // PRESENTATIONSERVICE_H

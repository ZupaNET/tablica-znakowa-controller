#include "presentationservice.h"

QList<Screen> PresentationService::build(int setId, bool showAll)
{
    QList<Screen> result;

    auto emptyScreen = Screen{
        -1,
        -1,
        QObject::tr("Pusty"),
        "",
        -1,
        0,
        true
    };

    result.append(emptyScreen);

    auto hymns = setRepo.getHymns(setId);

    foreach (const auto& hymn, hymns)
    {
        auto screens = setRepo.getScreens(setId, hymn.id);

        foreach (const auto& screen, screens)
        {
            if (screen.shown || showAll)
                result.append(screen);
        }

        result.append(emptyScreen);
    }

    return result;
}
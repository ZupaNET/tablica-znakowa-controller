#include "presentationservice.h"

QList<Screen> PresentationService::build(int setId)
{
    QList<Screen> result;

    result.append({
        -1,
        -1,
        "Pusty",
        "",
        -1,
        0
    });

    auto hymns = setRepo.getHymns(setId);

    foreach(const auto& hymn, hymns)
    {
        auto screens =
            screenRepo.getByHymn(hymn.id);


        foreach(const auto& screen, screens)
        {
            if(hymn.shownScreens.contains(screen.order))
            {
                result.append(screen);
            }
        }


        result.append({
            -1,
            -1,
            "Pusty",
            "",
            -1,
            0
        });
    }

    return result;
}
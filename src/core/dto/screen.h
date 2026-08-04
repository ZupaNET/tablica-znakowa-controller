#ifndef SCREEN_H
#define SCREEN_H

#include <QObject>
#include <QtQml>
#include <QString>

struct Screen {
    Q_GADGET

    Q_PROPERTY(int screenId MEMBER id)
    Q_PROPERTY(int hymnId MEMBER hymnId)
    Q_PROPERTY(QString hymnName MEMBER hymnName)
    Q_PROPERTY(QString text MEMBER text)
    Q_PROPERTY(int order MEMBER order)
    Q_PROPERTY(int font MEMBER font)
    Q_PROPERTY(bool shown MEMBER shown)

public:
    int id;
    int hymnId;
    QString hymnName;
    QString text;
    int order;
    int font;
    bool shown;

    bool operator==(const Screen& other) const
    {
        return
            id == other.id &&
            hymnId == other.hymnId &&
            hymnName == other.hymnName &&
            text == other.text &&
            order == other.order &&
            font == other.font;
    }
    bool operator!=(const Screen& other) const
    {
        return !(*this == other);
    }

    static Screen emptyScreen()
    {
        return Screen{
            -1,
            -1,
            QObject::tr("Pusty", "Screen"),
            "",
            -1,
            2,
            true
        };
    }
};
Q_DECLARE_METATYPE(Screen);

#endif // SCREEN_H

#ifndef DTO_H
#define DTO_H

#include <QObject>
#include <QString>
#include <QVariantList>

struct Hymn {
    int id;
    QString name;
    int categoryId;
    QVariantList shownScreens;
};

struct Screen {
    Q_GADGET

    Q_PROPERTY(int screenId MEMBER id)
    Q_PROPERTY(int hymnId MEMBER hymnId)
    Q_PROPERTY(QString hymnName MEMBER hymnName)
    Q_PROPERTY(QString text MEMBER text)
    Q_PROPERTY(int order MEMBER order)
    Q_PROPERTY(int font MEMBER font)

public:
    int id;
    int hymnId;
    QString hymnName;
    QString text;
    int order;
    int font;

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
};
Q_DECLARE_METATYPE(Screen);

struct Category {
    int id;
    QString name;
};

struct Set {
    int id;
    QString name;
};

#endif // DTO_H

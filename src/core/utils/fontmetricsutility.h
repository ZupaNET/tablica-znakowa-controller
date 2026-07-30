#ifndef FONTMETRICSUTILITY_H
#define FONTMETRICSUTILITY_H

#include <QObject>
#include <QtQml>
#include <QString>
#include <QHash>
#include <QMutex>

class FontMetricsUtility : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit FontMetricsUtility(QObject *parent = nullptr);

    Q_INVOKABLE int pixelSizeForHeight(int height, int fontId, bool forceArial = false) const;

    Q_INVOKABLE void clearCache();

private:

    struct FontDefinition
    {
        QString family;
        int rows;
    };

    struct CacheKey
    {
        int height;
        int fontId;
        bool forceArial;

        bool operator==(const CacheKey &other) const
        {
            return height == other.height && fontId == other.fontId && forceArial == other.forceArial;
        }
    };

    QVector<FontDefinition> m_fonts;

    mutable QHash<QString, int> m_cache;
    mutable QMutex m_cacheMutex;

    QString makeCacheKey(int height, int fontId, bool forceArial) const;
};

#endif // FONTMETRICSUTILITY_H

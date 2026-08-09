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

    Q_INVOKABLE qreal pixelSizeForHeight(int height, int fontId, bool forceArial = false) const;

    Q_INVOKABLE void clearCache();

private:

    struct FontDefinition
    {
        QString family;
        float rows;
        int maxCols;
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

    mutable QHash<QString, qreal> m_cache;
    mutable QMutex m_cacheMutex;

    QString makeCacheKey(int height, int fontId, bool forceArial) const;
};

#endif // FONTMETRICSUTILITY_H

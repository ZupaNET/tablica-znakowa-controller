#include "fontmetricsutility.h"

#include <QFont>
#include <QTextDocument>
#include <QTextOption>
#include <QFontMetrics>
#include <QAbstractTextDocumentLayout>

FontMetricsUtility::FontMetricsUtility(QObject *parent)
    : QObject(parent)
{
    m_fonts =
    {
        { "MiniSet2", 14.0f, 32 },
        { "MiniForma2", 11.5f, 32 },
        { "FreeSans", 9.0f, 21 }
    };
}

QString FontMetricsUtility::makeCacheKey(int height, int fontId, bool forceArial) const
{
    int normalizedHeight = (height / 4) * 4;

    return QString("%1_%2_%3")
        .arg(normalizedHeight)
        .arg(fontId)
        .arg(forceArial ? 1 : 0);
}

qreal FontMetricsUtility::pixelSizeForHeight(int height, int fontId, bool forceArial) const
{
    if (height <= 0)
        return 0;

    if (fontId < 0 || fontId >= m_fonts.size())
        return 0;

    const QString key = makeCacheKey(
        height,
        fontId,
        forceArial
        );

    {
        QMutexLocker locker(&m_cacheMutex);

        auto it = m_cache.constFind(key);

        if (it != m_cache.constEnd())
            return it.value();
    }

    const auto &fontInfo = m_fonts[fontId];

    const QString family =
        forceArial ? QStringLiteral("Arimo")
                   : fontInfo.family;

    const int columns = fontInfo.maxCols;
    const int rows = fontInfo.rows;

    QFont font;
    font.setFamily(family);
    font.setBold(forceArial);

    const qreal safety = 1;

    const qreal targetHeight =
        (static_cast<qreal>(height) / rows) * safety;

    QString sample;
    sample.fill(QChar('O'), columns);

    qreal low = 1.0;
    qreal high = 1.0;

    auto fits = [&](qreal pixelSize) -> bool
    {
        font.setPixelSize(qMax(1, qRound(pixelSize)));

        QFontMetricsF fm(font);

        const qreal lineHeight =
            fm.ascent()
            + fm.descent()
            + fm.leading();

        if (lineHeight > targetHeight)
            return false;

        if (forceArial)
        {
            const qreal charWidth =
                fm.horizontalAdvance(QChar('O'));

            const qreal textWidth =
                charWidth * columns;

            const qreal availableWidth =
                static_cast<qreal>(height) * 3.0 / 2.0;

            if (textWidth > availableWidth * safety)
                return false;
        }

        return true;
    };

    while (fits(high))
    {
        high *= 2.0;

        if (high > 512.0)
            break;
    }

    for (int i = 0; i < 32; ++i)
    {
        const qreal mid = (low + high) / 2.0;

        if (fits(mid))
            low = mid;
        else
            high = mid;
    }

    int result = qFloor(low);

    while (result > 1)
    {
        if (fits(result))
            break;

        --result;
    }

    {
        QMutexLocker locker(&m_cacheMutex);
        m_cache.insert(key, result);
    }

    return result;
}
void FontMetricsUtility::clearCache()
{
    QMutexLocker locker(&m_cacheMutex);
    m_cache.clear();
}
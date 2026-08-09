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

qreal FontMetricsUtility::pixelSizeForHeight(int height, int fontId, bool forceArial, int width) const
{
    if(height <= 0)
        return 0;

    if(fontId < 0 || fontId >= m_fonts.size())
        return 0;


    QString key = makeCacheKey(
        height,
        fontId,
        forceArial
        );


    {
        QMutexLocker locker(&m_cacheMutex);

        auto it = m_cache.constFind(key);

        if(it != m_cache.constEnd())
            return it.value();
    }


    QString family = forceArial ? "Arimo" : m_fonts[fontId].family;


    double rows = m_fonts[fontId].rows;


    QFont font;
    font.setFamily(family);
    font.setBold(forceArial);


    double targetLineHeight = height / rows;


    double low = 1;
    double high = height;
    double best = 1;


    const int charsPerLine = m_fonts[fontId].maxCols;

    while((high - low) > 0.1)
    {
        double mid = (low + high) / 2.0;

        font.setPixelSize(qRound(mid));

        QFontMetricsF fm(font);


        double lineHeight =
            fm.ascent()
            + fm.descent()
            + fm.leading();


        bool heightOk = lineHeight <= targetLineHeight;


        bool widthOk = true;


        if(forceArial && width > 0)
        {
            QString sample;

            for(int i = 0; i < charsPerLine; ++i)
                sample += "O";


            double textWidth = fm.horizontalAdvance(sample);

            widthOk = textWidth <= width;
        }


        if(heightOk && widthOk)
        {
            best = mid;
            low = mid;
        }
        else
        {
            high = mid;
        }
    }


    qreal result = best;


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
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
        { "MiniSet2", 14.0f },
        { "MiniForma2", 11.5f },
        { "FreeSans", 9.0f }
    };
}

QString FontMetricsUtility::makeCacheKey(int height, int fontId, bool forceArial) const
{
    return QString("%1_%2_%3").arg(height).arg(fontId).arg(forceArial ? 1 : 0);
}

int FontMetricsUtility::pixelSizeForHeight(int height, int fontId, bool forceArial) const
{
    if(height <= 0)
        return 0;

    if(fontId < 0 || fontId >= m_fonts.size())
        return 0;

    QString key = makeCacheKey(height, fontId, forceArial);

    {
        QMutexLocker locker(&m_cacheMutex);

        auto it = m_cache.constFind(key);

        if(it != m_cache.constEnd())
            return it.value();
    }

    QString family;

    if(forceArial)
        family = "Arimo";
    else
        family = m_fonts[fontId].family;

    const float rows = m_fonts[fontId].rows;

    QFont font;
    font.setFamily(family);
    font.setBold(forceArial);

    int low = 1;
    int high = height;
    int best = 1;

    while (low <= high)
    {
        int mid = (low + high) / 2;

        font.setPixelSize(mid);

        QTextDocument doc;
        doc.setDefaultFont(font);
        doc.setDocumentMargin(0);
        doc.setTextWidth(1000000);

        QString sample;

        int fullRows = static_cast<int>(floor(rows));
        bool halfRow = (rows - fullRows) > 0.01f;

        for(int i = 0; i < fullRows; ++i)
        {
            if(i)
                sample += '\n';

            sample += "Ag";
        }

        if(halfRow)
        {
            if(!sample.isEmpty())
                sample += '\n';

            sample += "Ag";
        }

        doc.setPlainText(sample);

        double required = doc.size().height();

        if(halfRow)
        {
            QFontMetrics metrics(font);
            required -= metrics.lineSpacing() * 0.5;
        }

        if(required <= height)
        {
            best = mid;
            low = mid + 1;
        }
        else
        {
            high = mid - 1;
        }
    }

    {
        QMutexLocker locker(&m_cacheMutex);
        m_cache.insert(key, best);
    }

    return best;
}

void FontMetricsUtility::clearCache()
{
    QMutexLocker locker(&m_cacheMutex);
    m_cache.clear();
}
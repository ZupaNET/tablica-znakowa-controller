#include "lineheighthelper.h"

#include <QQuickTextDocument>
#include <QTextBlock>
#include <QTextBlockFormat>
#include <QTextCursor>
#include <QTextDocument>

LineHeightHelper::LineHeightHelper(QObject *parent)
    : QObject{parent}
{}

qreal LineHeightHelper::lineHeight() const
{
    return m_lineHeight;
}

void LineHeightHelper::setLineHeight(qreal value)
{
    value = qMax<qreal>(0.0, value);

    if(qFuzzyCompare(m_lineHeight, value))
        return;

    m_lineHeight = value;

    emit lineHeightChanged();

    if(m_document)
        applyToDocument();
}

LineHeightHelper::Mode LineHeightHelper::lineHeightMode() const
{
    return m_lineHeightMode;
}

void LineHeightHelper::setLineHeightMode(Mode mode)
{
    if(m_lineHeightMode == mode)
        return;

    m_lineHeightMode = mode;

    emit lineHeightModeChanged();

    if(m_document)
        applyToDocument();
}

void LineHeightHelper::attach(QQuickTextDocument *quickDocument)
{
    detach();

    if(!quickDocument)
        return;

    QTextDocument *document = quickDocument->textDocument();

    if(!document)
        return;

    m_document = document;

    connect(document, &QTextDocument::contentsChange, this, &LineHeightHelper::documentContentsChange);

    applyToDocument();
}

void LineHeightHelper::detach()
{
    if(!m_document)
        return;

    disconnect(m_document, &QTextDocument::contentsChange, this, &LineHeightHelper::documentContentsChange);

    m_document = nullptr;
}

bool LineHeightHelper::isEnabled() const
{
    return m_lineHeight > 0.0;
}

void LineHeightHelper::applyToBlock(QTextBlock & block)
{
    if(!block.isValid())
        return;

    QTextBlockFormat current = block.blockFormat();

    QTextBlockFormat format;

    format.setAlignment(current.alignment());
    format.setTopMargin(current.topMargin());
    format.setBottomMargin(current.bottomMargin());
    format.setLeftMargin(current.leftMargin());
    format.setRightMargin(current.rightMargin());
    format.setTextIndent(current.textIndent());
    format.setIndent(current.indent());
    format.setNonBreakableLines(current.nonBreakableLines());

    if(!isEnabled())
    {
        format.clearProperty(QTextFormat::LineHeight);
        format.clearProperty(QTextFormat::LineHeightType);
    }
    else
    {
        format.setLineHeight(m_lineHeight, static_cast<int>(m_lineHeightMode));
    }

    if(current == format)
        return;

    QTextCursor cursor(block);

    cursor.mergeBlockFormat(format);
}

void LineHeightHelper::applyToDocument()
{
    if(!m_document || m_applying)
        return;

    m_applying = true;

    QTextDocument *document = m_document.data();

    for(QTextBlock block = document->begin(); block.isValid(); block = block.next())
    {
        applyToBlock(block);
    }

    m_applying = false;
}

void LineHeightHelper::applyToRange(int position, int charsRemoved, int charsAdded)
{
    if(!m_document || m_applying)
        return;

    QTextDocument *document = m_document.data();

    if(!document->characterCount())
        return;

    const int documentEnd = qMax(0, document->characterCount()-1);
    const int startPosition = qBound(0, position, documentEnd);
    const int endPosition = qBound(0, position + qMax(0, charsAdded), documentEnd);

    QTextBlock firstBlock = document->findBlock(startPosition);
    QTextBlock lastBlock = document->findBlock(endPosition);

    if(!firstBlock.isValid())
        return;

    QTextBlock previous = firstBlock.previous();

    if(previous.isValid())
        firstBlock = previous;

    m_applying = true;

    for(QTextBlock block = firstBlock; block.isValid(); block = block.next())
    {
        applyToBlock(block);
        if (block == lastBlock)
            break;
    }

    m_applying = false;
}

void LineHeightHelper::documentContentsChange(int position, int charsRemoved, int charsAdded)
{
    if(!m_document || m_applying)
        return;

    applyToRange(position, charsRemoved, charsAdded);
}
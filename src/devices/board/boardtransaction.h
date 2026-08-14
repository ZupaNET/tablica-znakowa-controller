#ifndef BOARDTRANSACTION_H
#define BOARDTRANSACTION_H

#include <QObject>
#include "domain/dto/screen.h"

class BoardCommandSession;

class BoardTransaction : public QObject
{
    Q_OBJECT
public:
    explicit BoardTransaction(const Screen& screen, QObject *parent = nullptr);

    void start();
    void cancel();

signals:
    void finished();
    void failed(const QString& error);
    void connectedChanged(bool connected);

private:
    void next();
    void startCommand();

    void commandFinished();
    void commandFailed(const QString &error);

    Screen m_screen;

    QStringList m_commands;
    int m_commandIndex = 0;

    BoardCommandSession *m_session = nullptr;
    bool m_cancelled = false;
    bool m_singleConnection = false;
};

#endif // BOARDTRANSACTION_H

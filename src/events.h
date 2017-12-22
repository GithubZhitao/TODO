#ifndef EVENTS_H
#define EVENTS_H

#include<QObject>
#include<QSettings>

class Events:public QObject
{
    Q_OBJECT
public:
    explicit Events(QObject *parent =0);

signals:

public slots:
    // get the events from items
    QVariantList getItems();

    //save the events from to items
    void saveItems(const QVariantList &list);

private:
    // use the ini file to save the todolist
    QSettings *settings;
};

#endif // EVENTS_H

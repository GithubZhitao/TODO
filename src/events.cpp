#include "events.h"
#include<QDebug>
#include<QStandardPaths>
Events::Events(QObject *parent)
{
    QString path = QStandardPaths::standardLocations(QStandardPaths::GenericDataLocation).first();\
    settings = new QSettings(path.append("../../TODO/todo1-2-3.ini"), QSettings::IniFormat);
}

QVariantList Events::getItems(){
    QVariantList list;
    int size = settings->beginReadArray("items");
    for(int i =0 ; i< size; i++){
        settings->setArrayIndex(i);
        QVariantMap m;
        m.insert("text",settings->value("text","").toString());
        m.insert("pri",settings->value("pri",99).toInt());
        m.insert("done",settings->value("done",false).toBool());

        if(!m.value("text").toString().isEmpty())
          list.push_back(m);
    }
    settings->endArray();
    return list;
}

void Events::saveItems(const QVariantList &list){
  settings->beginWriteArray("items");
  for(int i =0 ; i < list.size() ; i++){
      settings->setArrayIndex(i);
      if(!list.at(i).toMap().value("text").toString().isEmpty()){
          settings->setValue("text",list.at(i).toMap().value("text").toString());
          settings->setValue("pri",list.at(i).toMap().value("pri",99).toInt());
          settings->setValue("done",list.at(i).toMap().value("done",false).toBool());
          qDebug()<< list.at(i).toMap().value("text").toString();
      }
  }
  settings->endArray();
  settings->sync();
}

import QtQuick 2.2
import QtQuick.Window 2.1
import "."

Window {
    id: window
    visible: true

    //�����width��height���ã���Ӱ��APP����ʾ����Ϊ��QQmlApplicationEngine
    //Ĭ�ϻ���Window�����ʾ��
    //�������õ�ֵ�Ļ���������ģ�����ͨ���һ��ڿ������ڣ���дUIʱ��
    //����Desktop�Ĺ����׼���ֱ���ڿ���������PC����������UI��Ч����
    //���������豸���Կ���ˣ����ַ���������һ���ô��������ڱ�д
    //�Զ���Ӧ��Ļ��С��UIʱ���ҿ���ֱ���϶����ڴ�С����Ч����
    //���������width��heightֵ����ΪĿ���豸��ͨ�÷ֱ��ʡ�
    width: 480
    height: 1024

    //������ɫ
    Rectangle {
        id: backgroundColor
        anchors.fill: parent
        color: "#D9D2D2"
    }
	
    Column{
        anchors.fill: parent
        //������
        Titlebar{
            id: titlebar
            onStateChanged: {
                if(state == "default")
                    addview.hide();
                else if(state == "adding")
                    addview.show();
            }
    }
        //��������
       AddView {
            id: addview
            width: parent.width
            onAdded: {
                titlebar.state = "default"; //�ָ���������״̬
                if(intent.text !== ""){
                    intent.done = false;
                    list.insertItem(intent);
                    list.saveItems();
                }
            }
        }
        //����ӵ������б�
        TodoListView {
            id: list
            width: parent.width
            height: window.height - titlebar.height - addview.height
        }
    }
    //UI������ɺ󣬶�ȡ���������б�����ʾ����
    Component.onCompleted: {
        var l  = todocpp.getItems();
        console.debug(JSON.stringify(l));
        for(var i=0; i<l.length; ++i){
            list.insertItem(l[i]);
        }
    }
	
    //������Բ�׽Androidϵͳ�ķ��ذ����¼��������Ҫ�����η��ؾ��˳�����Ļ���������������
    //    Keys.onReleased: {
    //        if (event.key == Qt.Key_Back) {
    //             event.accepted = true;
    //        }
    //    }
}
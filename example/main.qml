import QtQuick 2.2
import QtQuick.Window 2.1
import "."

Window {
    id: window
    visible: true

    //这里的width和height设置，不影响APP的显示，因为在QQmlApplicationEngine
    //默认会让Window最大化显示。
    //这里设置的值的还是有意义的，比如通常我会在开发初期，编写UI时，
    //会用Desktop的构建套件，直接在开发环境的PC上启动来看UI的效果，
    //这样比用设备调试快多了，这种方法还有另一个好处，就是在编写
    //自动适应屏幕大小的UI时，我可以直接拖动窗口大小来看效果。
    //所以这里的width和height值设置为目标设备的通用分辨率。
    width: 480
    height: 1024

    //背景颜色
    Rectangle {
        id: backgroundColor
        anchors.fill: parent
        color: "#D9D2D2"
    }
	
    Column{
        anchors.fill: parent
        //标题栏
        Titlebar{
            id: titlebar
            onStateChanged: {
                if(state == "default")
                    addview.hide();
                else if(state == "adding")
                    addview.show();
            }
    }
        //增加事项
       AddView {
            id: addview
            width: parent.width
            onAdded: {
                titlebar.state = "default"; //恢复标题栏的状态
                if(intent.text !== ""){
                    intent.done = false;
                    list.insertItem(intent);
                    list.saveItems();
                }
            }
        }
        //已添加的事项列表
        TodoListView {
            id: list
            width: parent.width
            height: window.height - titlebar.height - addview.height
        }
    }
    //UI构建完成后，读取待办事项列表，并显示出来
    Component.onCompleted: {
        var l  = todocpp.getItems();
        console.debug(JSON.stringify(l));
        for(var i=0; i<l.length; ++i){
            list.insertItem(l[i]);
        }
    }
	
    //这里可以捕捉Android系统的返回按键事件，如果需要按两次返回就退出软件的话，可以在这里做
    //    Keys.onReleased: {
    //        if (event.key == Qt.Key_Back) {
    //             event.accepted = true;
    //        }
    //    }
}
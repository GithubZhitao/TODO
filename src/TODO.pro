TEMPLATE = app
TARGET = TODO
QT += quick

SOURCES += \
    main.cpp \
    events.cpp

RESOURCES += \
    TODO.qrc

OTHER_FILES += \
    main.qml

DISTFILES += \
    Content.qml \
    SettingsIcon.qml \
    ActionButton.qml \
    AddView.qml \
    Collec.qml \
    Content.qml \
    InputEvent.qml \
    Line.qml \
    Titlebar.qml \
    TodoListView.qml
	

target.path = $$[QT_INSTALL_EXAMPLES]/quickcontrols/extras/TODO
INSTALLS += target

HEADERS += \
    events.h

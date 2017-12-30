import QtQuick 2.7
import QtQuick.Window 2.2

Window {
    visible: true
    width: 800
    height: 800
    title: qsTr("Hello World")
    GameBoard{
        id: gameBoard
    }
}

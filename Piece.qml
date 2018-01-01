import QtQuick 2.0

Rectangle {
    property color pieceColor:"red"
    id : piece
    width: 80
    height: width
    radius: width/2
    color: "black"
    Rectangle{
        id : innerCircle
        width: 74
        height: width
        radius: width/2
        color: parent.pieceColor
        anchors.centerIn: parent
    }
}


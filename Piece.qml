import QtQuick 2.0

Rectangle {
    property color transitionColor: "red"
    property color pieceColor: "red"
    property string team;
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

    function lightenPiece(){
        transitionColor = pieceColor
        pieceColor = Qt.lighter(transitionColor, 1.5)
    }
    function darkenPiece(){
        pieceColor = transitionColor
    }
}


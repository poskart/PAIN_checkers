import QtQuick 2.0

Rectangle {
    id: tile
    property int row;
    property int col;
    property Piece piece;
    property color transitionColor
    property var directionToCapture: null

    width: 100
    height: width
    color: (row + col) % 2 ? "white" : "#443311"

    function lightenTile(){
        transitionColor = tile.color
        color = Qt.lighter(transitionColor, 1.9)
    }
    function darkenTile(){
        tile.color = transitionColor
    }
}

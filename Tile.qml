import QtQuick 2.0

Rectangle {
    id: tile
    property int row;
    property int col;
    property Piece piece;
    width: 100
    height: width
    color: (row + col) % 2 ? "white" : "#443311"
}

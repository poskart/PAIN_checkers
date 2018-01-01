import QtQuick 2.7

Item {
    id: gameBoard
    width: 800
    height: width

    Grid{
        id: grid
        rows: 8
        columns: 8
        Repeater {
            model: 64
            Tile{
                id: tile
                row: index / 8
                col: index % 8

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("Nacisnieto tile")
                    }
                }

                Component.onCompleted: {
                    if(row % 2 == col % 2)
                    {
                        if(tile.row <= 2){
                            var component = Qt.createComponent("Piece.qml");
                            tile.piece = component.createObject(tile);
                            tile.piece.pieceColor = "white"
                            tile.piece.anchors.centerIn = tile
                        }
                        else if(tile.row >= 5){
                            var component = Qt.createComponent("Piece.qml");
                            tile.piece = component.createObject(tile);
                            tile.piece.pieceColor = "red"
                            tile.piece.anchors.centerIn = tile
                        }
                    }
                }
            }
        }
    }
}

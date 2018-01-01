import QtQuick 2.7

Item {
    id: gameBoard
    width: 800
    height: width
    state: "whiteTurn"

    property Piece clickedPiece;
    property Tile clickedTileWithPiece;
    property int whiteDirection: 1
    property int blackDirection: -1

    states: [
        State {
            name: "whiteTurn"
        },
        State {
            name: "blackTurn"
        }
    ]

    function handleMove(targetTile){
        if(targetTile.row % 2 == targetTile.col % 2 &&
                goodDirectionChoosen(clickedPiece, targetTile)){
            clickedPiece.parent = targetTile
            targetTile.piece = clickedPiece
            clickedTileWithPiece.piece = null
            nextTurn()
        }
        clickedPiece = null
        clickedTileWithPiece = null
    }

    function validPieceTurn(piece){
        if(state == "whiteTurn" && piece.team === "white" ||
                state == "blackTurn" && piece.team === "black")
            return true
        return false
    }

    function nextTurn(){
        if(state == "whiteTurn")
            state = "blackTurn"
        else
            state = "whiteTurn"
    }

    function canCaptureOpponent(srcTile, targetTile, thisTeam){
        if(true);
    }

    function goodDirectionChoosen(piece, targetTile){
        if(piece.team === "white"){
            if(piece.parent.row * whiteDirection < targetTile.row * whiteDirection){
                return true
            }
        }
        else{
            if(piece.parent.row * blackDirection < targetTile.row * blackDirection){
                return true
            }
        }
    }

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
                        if(clickedPiece != null)
                            clickedPiece.darkenPiece()
                        if(tile.piece != null){
                            if(validPieceTurn(tile.piece)){
                                clickedTileWithPiece = tile
                                clickedPiece = tile.piece
                                tile.piece.lightenPiece()
                                console.log("Clicked on piece")
                            }
                        }
                        else{
                            if(clickedPiece != null &&
                                    validPieceTurn(clickedPiece)){
                                handleMove(tile)
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    if(row % 2 == col % 2)
                    {
                        if(tile.row <= 2){
                            var component = Qt.createComponent("Piece.qml");
                            tile.piece = component.createObject(tile);
                            tile.piece.pieceColor = "#DDDD99"
                            tile.piece.team = "white"
                            tile.piece.anchors.centerIn = tile
                        }
                        else if(tile.row >= 5){
                            var component = Qt.createComponent("Piece.qml");
                            tile.piece = component.createObject(tile);
                            tile.piece.pieceColor = "red"
                            tile.piece.team = "black"
                            tile.piece.anchors.centerIn = tile
                        }
                    }
                }
            }
        }
    }
}

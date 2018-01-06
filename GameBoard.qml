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
    property var lightenedTiles

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

    function getPossibleCaptures(srcTile, srcPiece, clickedDestTile){
        var validTiles = new Array()

        if(!crossesTheBoard(srcTile, Qt.point(2, 2*srcPiece.direction))){
            var nextTile = getNextTile(srcTile, Qt.point(2, 2*srcPiece.direction))
            if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, srcTile, srcPiece, validTiles) &&
                    clickedDestTile != null){
                srcTile.directionToCapture = Qt.point(2, 2*srcPiece.direction)
            }
        }
        if(!crossesTheBoard(srcTile, Qt.point(-2, 2*srcPiece.direction))){
            var nextTile = getNextTile(srcTile, Qt.point(-2, 2*srcPiece.direction))
            if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, srcTile, srcPiece, validTiles) &&
                    clickedDestTile != null){
                srcTile.directionToCapture = Qt.point(-2, 2*srcPiece.direction)
            }
        }
        if(srcPiece.isKing){
            if(!crossesTheBoard(srcTile, Qt.point(2, -2*srcPiece.direction))){
                var nextTile = getNextTile(srcTile, Qt.point(2, -2*srcPiece.direction))
                if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, srcTile, srcPiece, validTiles) &&
                        clickedDestTile != null){
                    srcTile.directionToCapture = Qt.point(2, -2*srcPiece.direction)
                }
            }
            if(!crossesTheBoard(srcTile, Qt.point(-2, -2*srcPiece.direction))){
                var nextTile = getNextTile(srcTile, Qt.point(-2, -2*srcPiece.direction))
                if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, srcTile, srcPiece, validTiles) &&
                        clickedDestTile != null){
                    srcTile.directionToCapture = Qt.point(-2, -2*srcPiece.direction)
                }
            }
        }

        return validTiles
    }

    function checkPossibleCaptures(srcTile, clickedDestTile, currentTile, prevTile, srcPiece, validTiles){
        if(srcTile == currentTile || currentTile.piece != null)
            return false;
        if(currentTile == clickedDestTile)
            return true;
        if(capturesEnemy(prevTile, currentTile, srcPiece)){
            validTiles.push(currentTile)
            if(!crossesTheBoard(currentTile, Qt.point(2, 2*srcPiece.direction))){
                var nextTile = getNextTile(currentTile, Qt.point(2, 2*srcPiece.direction))
                if(nextTile != prevTile){
                    if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, currentTile, srcPiece, validTiles) &&
                            clickedDestTile != null){
                        currentTile.directionToCapture = Qt.point(2, 2*srcPiece.direction)
                        return true
                    }
//                    else
//                        return false
                }
            }
            if(!crossesTheBoard(currentTile, Qt.point(-2, 2*srcPiece.direction))){
                var nextTile = getNextTile(currentTile, Qt.point(-2, 2*srcPiece.direction))
                if(nextTile != prevTile){
                    if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, currentTile, srcPiece, validTiles) &&
                            clickedDestTile != null){
                        currentTile.directionToCapture = Qt.point(-2, 2*srcPiece.direction)
                        return true
                    }
//                    else
//                        return false
                    }
            }
            if(srcPiece.isKing){
                if(!crossesTheBoard(currentTile, Qt.point(2, -2*srcPiece.direction))){
                    var nextTile = getNextTile(currentTile, Qt.point(2, -2*srcPiece.direction))
                    if(nextTile != prevTile){
                        if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, currentTile, srcPiece, validTiles) &&
                                clickedDestTile != null){
                            currentTile.directionToCapture = Qt.point(2, -2*srcPiece.direction)
                            return true
                        }
//                        else
//                            return false
                        }
                }
                if(!crossesTheBoard(currentTile, Qt.point(-2, -2*srcPiece.direction))){
                    var nextTile = getNextTile(currentTile, Qt.point(-2, -2*srcPiece.direction))
                    if(nextTile != prevTile){
                        if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, currentTile, srcPiece, validTiles) &&
                                clickedDestTile != null){
                            currentTile.directionToCapture = Qt.point(-2, -2*srcPiece.direction)
                            return true
                        }
//                        else
//                            return false
                    }
                }
            }
        }
    }

    function getNextTile(srcTile, moveOffset){
        var newColumn = srcTile.col + moveOffset.x
        var newRow = srcTile.row + moveOffset.y
        var index = newRow*grid.columns+newColumn
        var tileBetween = tilesRepeater.itemAt(index)
        return tileBetween
    }

    function crossesTheBoard(srcTile, moveOffset){
        if(srcTile.row + moveOffset.y >= grid.rows ||
                srcTile.row + moveOffset.y < 0 ||
                srcTile.col + moveOffset.x >= grid.columns ||
                srcTile.col + moveOffset.x < 0)
            return true
        return false
    }

    function capturesEnemy(srcTile, targetTile, srcPiece){
        var newColumn = (srcTile.col + targetTile.col)/2
        var newRow = (srcTile.row + targetTile.row)/2
        var index = newRow*grid.columns+newColumn
        var tileBetween = tilesRepeater.itemAt(index)
        if(tileBetween.piece != null && tileBetween.piece.team != srcPiece.team)
            return true
        return false
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
            id: tilesRepeater
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
                        if(lightenedTiles != null){
                            for(var i = 0; i < lightenedTiles.length; ++i){
                                lightenedTiles[i].darkenPiece()
                            }
                            lightenedTiles = null
                        }

                        if(tile.piece != null){
                            if(validPieceTurn(tile.piece)){
                                clickedTileWithPiece = tile
                                clickedPiece = tile.piece
                                tile.piece.lightenPiece()
                                lightenedTiles = getPossibleCaptures(tile, clickedPiece, null)
                                for(var i = 0; i < lightenedTiles.length; ++i){
                                    lightenedTiles[i].lightenPiece()
                                }

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
                            tile.piece.direction = 1
                            tile.piece.anchors.centerIn = tile
                        }
                        else if(tile.row >= 5){
                            var component = Qt.createComponent("Piece.qml");
                            tile.piece = component.createObject(tile);
                            tile.piece.pieceColor = "red"
                            tile.piece.team = "black"
                            tile.piece.direction = -1
                            tile.piece.anchors.centerIn = tile
                        }
                    }
                }
            }
        }
    }
}

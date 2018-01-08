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
    property int blackPiecesCount: 12
    property int whitePiecesCount: 12
    property alias gameOverText: gameOverTextBox

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
            if(diagonalNeighbour(clickedTileWithPiece, targetTile)){
                clickedPiece.parent = targetTile
                targetTile.piece = clickedPiece
                clickedTileWithPiece.piece = null
                checkChangeToKing(targetTile)
                nextTurn()
            }
            else{
                getPossibleCaptures(clickedTileWithPiece, clickedPiece, targetTile)
                if(clickedTileWithPiece.directionToCapture != null){
                    captureEnemyUsingSavedPath(clickedTileWithPiece, clickedPiece)
                    checkChangeToKing(targetTile)
                    nextTurn()
                }
            }
        }
        clickedPiece = null
        clickedTileWithPiece = null
    }

    function diagonalNeighbour(tile1, tile2){
        var rowDiff = Math.abs(tile1.row - tile2.row)
        var colDiff = Math.abs(tile1.col - tile2.col)
        if(rowDiff == 1 && colDiff == 1)
            return true
        return false
    }

    function addDirectionToTile(tile, direction){
        tile.directionToCapture = direction;
    }

    function decreasePiecesCount(srcPiece){
        if(srcPiece.team == "white"){
            whitePiecesCount--;
            console.log("wywalono białego, jest ich: ", whitePiecesCount)
        }
        else if(srcPiece.team == "black"){
            blackPiecesCount--;
            console.log("wywalono czarnego, jest ich: ", blackPiecesCount)
        }
    }

    function getPossibleCaptures(srcTile, srcPiece, clickedDestTile){
        var validTiles = new Array()

        if(!crossesTheBoard(srcTile, Qt.point(2, 2*srcPiece.direction))){
            var nextTile = getNextTile(srcTile, Qt.point(2, 2*srcPiece.direction))
            if(capturesEnemy(srcTile, nextTile, srcPiece) &&
                    checkPossibleCaptures(srcTile, clickedDestTile, nextTile, srcTile, srcPiece, validTiles) &&
                    clickedDestTile != null){
                addDirectionToTile(srcTile, Qt.point(2, 2*srcPiece.direction))
            }
        }
        if(!crossesTheBoard(srcTile, Qt.point(-2, 2*srcPiece.direction))){
            var nextTile = getNextTile(srcTile, Qt.point(-2, 2*srcPiece.direction))
            if(capturesEnemy(srcTile, nextTile, srcPiece) &&
                    checkPossibleCaptures(srcTile, clickedDestTile, nextTile, srcTile, srcPiece, validTiles) &&
                    clickedDestTile != null){
                addDirectionToTile(srcTile, Qt.point(-2, 2*srcPiece.direction))
            }
        }
        if(srcPiece.isKing){
            if(!crossesTheBoard(srcTile, Qt.point(2, -2*srcPiece.direction))){
                var nextTile = getNextTile(srcTile, Qt.point(2, -2*srcPiece.direction))
                if(capturesEnemy(srcTile, nextTile, srcPiece) &&
                        checkPossibleCaptures(srcTile, clickedDestTile, nextTile, srcTile, srcPiece, validTiles) &&
                        clickedDestTile != null){
                    addDirectionToTile(srcTile, Qt.point(2, -2*srcPiece.direction))
                }
            }
            if(!crossesTheBoard(srcTile, Qt.point(-2, -2*srcPiece.direction))){
                var nextTile = getNextTile(srcTile, Qt.point(-2, -2*srcPiece.direction))
                if(capturesEnemy(srcTile, nextTile, srcPiece) &&
                        checkPossibleCaptures(srcTile, clickedDestTile, nextTile, srcTile, srcPiece, validTiles) &&
                        clickedDestTile != null){
                    addDirectionToTile(srcTile, Qt.point(-2, -2*srcPiece.direction))
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
                        addDirectionToTile(currentTile, Qt.point(2, 2*srcPiece.direction))
                        return true
                    }
                }
            }
            if(!crossesTheBoard(currentTile, Qt.point(-2, 2*srcPiece.direction))){
                var nextTile = getNextTile(currentTile, Qt.point(-2, 2*srcPiece.direction))
                if(nextTile != prevTile){
                    if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, currentTile, srcPiece, validTiles) &&
                            clickedDestTile != null){
                        addDirectionToTile(currentTile, Qt.point(-2, 2*srcPiece.direction))
                        return true
                    }
                }
            }
            if(srcPiece.isKing){
                if(!crossesTheBoard(currentTile, Qt.point(2, -2*srcPiece.direction))){
                    var nextTile = getNextTile(currentTile, Qt.point(2, -2*srcPiece.direction))
                    if(nextTile != prevTile){
                        if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, currentTile, srcPiece, validTiles) &&
                                clickedDestTile != null){
                            addDirectionToTile(currentTile, Qt.point(2, -2*srcPiece.direction))
                            return true
                        }
                    }
                }
                if(!crossesTheBoard(currentTile, Qt.point(-2, -2*srcPiece.direction))){
                    var nextTile = getNextTile(currentTile, Qt.point(-2, -2*srcPiece.direction))
                    if(nextTile != prevTile){
                        if(checkPossibleCaptures(srcTile, clickedDestTile, nextTile, currentTile, srcPiece, validTiles) &&
                                clickedDestTile != null){
                            addDirectionToTile(currentTile, Qt.point(-2, -2*srcPiece.direction))
                            return true
                        }
                    }
                }
            }
        }
    }

    function captureEnemyUsingSavedPath(srcTile, srcPiece){
        var currTile = srcTile
        var nextTile
        var tileToCapture
        while(currTile.directionToCapture != null){
            nextTile = getNextTile(currTile, currTile.directionToCapture)
            tileToCapture = getTileBetween(currTile, nextTile)
            if(tileToCapture.piece != null){
                tileToCapture.piece.destroy()
                decreasePiecesCount(tileToCapture.piece)
            }
            tileToCapture.piece = null
            currTile.directionToCapture = null
            nextTile.piece = currTile.piece
            nextTile.piece.parent = nextTile
            currTile.piece = null
            currTile = nextTile
        }
    }

    function getTileBetween(tile1, tile2){
        var rowBetween = (tile1.row + tile2.row)/2
        var colBetween = (tile1.col + tile2.col)/2
        var index = rowBetween*grid.columns+colBetween
        return tilesRepeater.itemAt(index)
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
        var tileBetween = getTileBetween(srcTile, targetTile)
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
        if(piece.isKing == true)
            return true
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
        return false;
    }

    function checkChangeToKing(srcTile){
        if(srcTile.piece != null){
            if(crossesTheBoard(srcTile, Qt.point(0, srcTile.piece.direction)))
                srcTile.piece.isKing = true;
        }
    }

    function addHighlightOfTheDiagonalNeighbours(srcTile, highlightedTiles){
        var diagonalNeighbourTile;
        if(!crossesTheBoard(srcTile, Qt.point(1, 1*srcTile.piece.direction))){
            diagonalNeighbourTile = getNextTile(srcTile, Qt.point(1, 1*srcTile.piece.direction))
            if(diagonalNeighbourTile.piece == null)
                highlightedTiles.push(diagonalNeighbourTile)
        }
        if(!crossesTheBoard(srcTile, Qt.point(-1, 1*srcTile.piece.direction))){
            diagonalNeighbourTile = getNextTile(srcTile, Qt.point(-1, 1*srcTile.piece.direction))
            if(diagonalNeighbourTile.piece == null)
                highlightedTiles.push(diagonalNeighbourTile)
        }
        if(srcTile.piece.isKing){
            if(!crossesTheBoard(srcTile, Qt.point(1, -1*srcTile.piece.direction))){
                diagonalNeighbourTile = getNextTile(srcTile, Qt.point(1, -1*srcTile.piece.direction))
                if(diagonalNeighbourTile.piece == null)
                    highlightedTiles.push(diagonalNeighbourTile)
            }
            if(!crossesTheBoard(srcTile, Qt.point(-1, -1*srcTile.piece.direction))){
                diagonalNeighbourTile = getNextTile(srcTile, Qt.point(-1, -1*srcTile.piece.direction))
                if(diagonalNeighbourTile.piece == null)
                    highlightedTiles.push(diagonalNeighbourTile)
            }
        }
    }

    function lightenTiles(tiles){
        for(var i = 0; i < tiles.length; ++i){
            tiles[i].lightenTile()
        }
    }

    function darkenTiles(tiles){
        for(var i = 0; i < tiles.length; ++i){
            tiles[i].darkenTile()
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
                            darkenTiles(lightenedTiles)
                            lightenedTiles = null
                        }

                        if(tile.piece != null){
                            if(validPieceTurn(tile.piece)){
                                clickedTileWithPiece = tile
                                clickedPiece = tile.piece
                                tile.piece.lightenPiece()
                                lightenedTiles = getPossibleCaptures(tile, clickedPiece, null)
                                addHighlightOfTheDiagonalNeighbours(tile, lightenedTiles)
                                lightenTiles(lightenedTiles)

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
    Rectangle{
        id: gameOverScreen
        anchors.fill: parent
        opacity: 0
        color: "#AAAAFF"
        Text{
            id: gameOverTextBox
            text: ""
            font.pointSize: 44
            color: "black"
            anchors.centerIn: parent
        }
    }
    onWhitePiecesCountChanged: {
        if(whitePiecesCount == 0){
            gameOverText.text = "RED IS THE WINNER!"
            gameOverScreen.opacity = 1
        }
    }
    onBlackPiecesCountChanged: {
        if(blackPiecesCount == 0){
            gameOverText.text = "WHITE IS THE WINNER!"
            gameOverScreen.opacity = 1
        }
    }
}

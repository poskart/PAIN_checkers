import QtQuick 2.7

Item {
    id: root
    width: 800
    height: width

    Grid{
        id: grid
        rows: 8
        columns: 8
        Repeater {
            model: 64
            Rectangle {
                property int row: (index / 8)
                property int col: (index % 8)
                width: 100
                height: width
                color: (row + col) % 2 ? "black" : "white"
                Text{
                    anchors.centerIn: parent
                    text: row+"x"+col
                }
            }
        }
    }
}

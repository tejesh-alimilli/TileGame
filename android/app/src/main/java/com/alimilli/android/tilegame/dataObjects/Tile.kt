package com.alimilli.android.tilegame.dataObjects

class Tile(initPosition: TilePosition, content: Int?) {
    val actualPosition = initPosition
    var currentPosition = initPosition
    val content = content

    var isEmpty = false
        get() = content == null

    override fun toString(): String {
        val contentString = content?.toString() ?: "Empty Tile"
        return "$contentString was at $actualPosition, now at $currentPosition"
    }
}

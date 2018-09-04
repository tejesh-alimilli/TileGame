package com.alimilli.android.tilegame.dataObjects

data class TileMovement(var from: TilePosition, var to: TilePosition) {
    fun equals(other: TileMovement?): Boolean {
        if (other == null) {
            return false
        }
        return from == other.from && to == other.to
    }
}

package com.alimilli.android.tilegame.dataObjects

data class TilePosition(var row: Int = 0, var column: Int = 0) {
    fun equals(other: TilePosition?): Boolean {
        if (other == null) {
            return false
        }
        return row == other.row && column == other.column
    }

    override fun toString(): String {
        return "row $row column $column"
    }
}

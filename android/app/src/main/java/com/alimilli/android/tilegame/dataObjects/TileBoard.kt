package com.alimilli.android.tilegame.dataObjects

import java.util.Random

class TileBoard(rows: Int, cols: Int) {
    val rowsCount = rows
    val columnsCount = cols

    var movesCount = 0

    var tiles = emptyArray<Tile>()
    private val emptyTile: Tile
    init {
        val emptyTilePosition = TilePosition(row = rowsCount - 1, column = columnsCount - 1)
        emptyTile = Tile(initPosition = emptyTilePosition, content = null)

        for (row in 0 until rowsCount) {
            for (col in 0 until columnsCount) {
                val position = TilePosition(row = row, column = col)
                if (position == emptyTilePosition) {
                    tiles += emptyTile
                    continue
                }

                val content: Int? = col + (row * columnsCount) + 1
                val tile = Tile(initPosition = position, content = content)
                tiles += tile
            }
        }
    }

    fun tilePositionAtLinearIndex(linearIndex: Int): TilePosition? {
        if (linearIndex < 0 || linearIndex > (rowsCount * columnsCount)) {
            return null
        }

        val col = linearIndex % columnsCount
        val row = (linearIndex - col) / columnsCount

        return TilePosition(row = row, column = col)
    }

    fun tileAtLinearIndex(linearIndex: Int): Tile? {
        val position = tilePositionAtLinearIndex(linearIndex = linearIndex)

        return tile(position)
    }

    fun tileAt(row: Int, col: Int): Tile? {
        for (tile in tiles) {
            if (tile.currentPosition.row == row && tile.currentPosition.column == col) {
                return tile
            }
        }
        return null
    }

    fun tile(atPosition: TilePosition?): Tile? {
        if (atPosition == null) {
            return null
        }
        return tileAt(row = atPosition.row, col = atPosition.column)
    }

    fun canMoveTile(atPosition: TilePosition): Boolean {
        if (emptyTile.currentPosition == atPosition) {
            return false
        }
        if (emptyTile.currentPosition.row == atPosition.row || emptyTile.currentPosition.column == atPosition.column) {
            return true
        }

        return false
    }

    fun moveTile(atPosition: TilePosition): Array<TileMovement> {
        var movements = emptyArray<TileMovement>()
        val direction: Int

        if (emptyTile.currentPosition.row == atPosition.row) {
            val columnRange: ClosedRange<Int>
            if (atPosition.column > emptyTile.currentPosition.column) {
                columnRange = emptyTile.currentPosition.column..atPosition.column
                direction = -1
            } else {
                columnRange = atPosition.column..emptyTile.currentPosition.column
                direction = 1
            }

            for (i in columnRange) {
                val from = TilePosition(row = atPosition.row, column = i)
                val to = TilePosition(row = atPosition.row, column = i + direction)
                if (to.column > columnRange.endInclusive) {
                    to.column = columnRange.start
                }
                if (to.column < columnRange.start) {
                    to.column = columnRange.endInclusive
                }
                movements += TileMovement(from = from, to = to)
            }
        } else if (emptyTile.currentPosition.column == atPosition.column) {
            val rowRange: ClosedRange<Int>
            if (atPosition.row > emptyTile.currentPosition.row) {
                rowRange = emptyTile.currentPosition.row..atPosition.row
                direction = -1
            } else {
                rowRange = atPosition.row..emptyTile.currentPosition.row
                direction = 1
            }

            for (i in rowRange) {
                val from = TilePosition(row = i, column = atPosition.column)
                val to = TilePosition(row = i + direction, column = atPosition.column)
                if (to.row > rowRange.endInclusive) {
                    to.row = rowRange.start
                }
                if (to.row < rowRange.start) {
                    to.row = rowRange.endInclusive
                }
                movements += TileMovement(from = from, to = to)
            }
        }

        // move all tiles at a time
        var tilesToMove = emptyArray<Tile>()
        for (movement in movements) {
            val fromTile = tile(atPosition = movement.from)
            if (fromTile != null) {
                tilesToMove += fromTile
            }
        }
        for (movementIndex in 0 until movements.size) {
            val tileToMove = tilesToMove[movementIndex]
            tileToMove.currentPosition = movements[movementIndex].to
        }

        movesCount += movements.size - 1

        return movements
    }

    private fun makeRandomMove(): Array<TileMovement> {
        if (tiles.isEmpty()) {
            return emptyArray()
        }

        val maxTries = tiles.size * 10
        for (i in 0 until maxTries) {
            val randomIndex = Random().nextInt(tiles.size)
            val randomTile = tiles[randomIndex]
            if (! canMoveTile(atPosition = randomTile.currentPosition)) {
                continue
            }

            return moveTile(atPosition = randomTile.currentPosition)
        }

        print("not able to find random movable tile")
        return emptyArray()
    }

    fun shuffle(): Array<TileMovement> {
        val currentPositions = tiles.map {
            it.currentPosition
        }

        for (i in 0 until 100) {
            makeRandomMove()
        }

        val shuffledPositions = tiles.map {
            it.currentPosition
        }

        var movements = emptyArray<TileMovement>()
        for (i in 0 until currentPositions.size) {
            val movement = TileMovement(from = currentPositions[i], to = shuffledPositions[i])
            movements += movement
        }

        movesCount = 0

        return movements
    }

    fun isComplete(): Boolean {
        for (tile in tiles) {
            if (tile.currentPosition != tile.actualPosition) {
                return false
            }
        }
        return true
    }
}

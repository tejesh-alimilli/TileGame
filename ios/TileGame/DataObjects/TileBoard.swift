//
//  TileBoard.swift
//  TileGame
//
//  Created by MCC on 13/4/18.
//  Copyright © 2018 Tejesh Alimilli. All rights reserved.
//

import Foundation

class TileBoard {
    let rowsCount: Int
    let columnsCount: Int
    
    var tiles: [Tile]
    let emptyTile: Tile
    
    var movesCount = 0
    
    init(rows: Int, cols: Int) {
        rowsCount = rows
        columnsCount = cols
        tiles = [Tile]()
        let emptyTilePosition = TilePosition(row: rows - 1, column: cols - 1)
        emptyTile = Tile(position: emptyTilePosition, content: nil)
        
        for row in 0..<rows {
            for col in 0..<cols {
                let position = TilePosition(row: row, column: col)
                if (position == emptyTilePosition) {
                    tiles.append(emptyTile)
                    continue
                }
                
                let content: Int? = row + (col * rowsCount) + 1
                let tile = Tile(position: position, content: content)
                tiles.append(tile)
            }
        }
    }
    
    func tileAt(row: Int, col: Int) -> Tile? {
        for tile in tiles {
            if tile.currentPosition.row == row && tile.currentPosition.column == col {
                return tile
            }
        }
        return nil
    }
    
    func tile(at position: TilePosition) -> Tile? {
        return tileAt(row: position.row, col: position.column)
    }
    
    func canMoveTile(at position: TilePosition) -> Bool {
        if emptyTile.currentPosition == position {
            return false
        }
        if emptyTile.currentPosition.row == position.row || emptyTile.currentPosition.column == position.column {
            return true
        }
        
        return false
    }
    
    func moveTile(at position: TilePosition) -> [TileMovement] {
        var movements = [TileMovement]()
        
        let direction: Int
        if emptyTile.currentPosition.row == position.row {
            let columnRange: CountableClosedRange<Int>
            if position.column > emptyTile.currentPosition.column {
                columnRange = emptyTile.currentPosition.column...position.column
                direction = -1
            } else {
                columnRange = position.column...emptyTile.currentPosition.column
                direction = 1
            }
            
            for i in columnRange {
                let from = TilePosition(row: position.row, column: i)
                var to = TilePosition(row: position.row, column: i + direction)
                if to.column > columnRange.upperBound {
                    to.column = columnRange.lowerBound
                }
                if to.column < columnRange.lowerBound {
                    to.column = columnRange.upperBound
                }
                movements.append(TileMovement(from: from, to: to))
            }
        } else if emptyTile.currentPosition.column == position.column {
            let rowRange: CountableClosedRange<Int>
            if position.row > emptyTile.currentPosition.row {
                rowRange = emptyTile.currentPosition.row...position.row
                direction = -1
            } else {
                rowRange = position.row...emptyTile.currentPosition.row
                direction = 1
            }
            
            for i in rowRange {
                let from = TilePosition(row: i, column: position.column)
                var to = TilePosition(row: i + direction, column: position.column)
                if to.row > rowRange.upperBound {
                    to.row = rowRange.lowerBound
                }
                if to.row < rowRange.lowerBound {
                    to.row = rowRange.upperBound
                }
                movements.append(TileMovement(from: from, to: to))
            }
        }
        
        // move all tiles at a time
        var tilesToMove = [Tile]()
        for movement in movements {
            if let fromTile = tile(at: movement.from) {
                tilesToMove.append(fromTile)
            }
        }
        for movementIndex in 0..<movements.count {
            let tileToMove = tilesToMove[movementIndex]
            tileToMove.currentPosition = movements[movementIndex].to
        }
        
        movesCount += movements.count - 1
        
        return movements
    }
    
    @discardableResult func makeRandomMove() -> [TileMovement] {
        if tiles.isEmpty {
            return []
        }
        
        let maxTries = tiles.count * 10
        for _ in 0..<maxTries {
            let randomIndex = Int(arc4random_uniform(UInt32(tiles.count)))
            let randomTile = tiles[randomIndex]
            if canMoveTile(at: randomTile.currentPosition) == false {
                continue
            }
            
            return moveTile(at: randomTile.currentPosition)
        }
        
        print("not able to find random movable tile")
        return []
    }
    
    func shuffle() -> [TileMovement] {
        let currentPositions = tiles.map { (tile) -> TilePosition in
            return tile.currentPosition
        }
        
        for _ in 0..<100 {
            makeRandomMove()
        }
        
        let shuffledPositions = tiles.map { (tile) -> TilePosition in
            return tile.currentPosition
        }
        
        var movements = [TileMovement]()
        for i in 0..<currentPositions.count {
            let movement = TileMovement(from: currentPositions[i], to: shuffledPositions[i])
            movements.append(movement)
        }
        
        movesCount = 0
        
        return movements
    }
    
    func isComplete() -> Bool {
        for tile in tiles {
            if tile.currentPosition != tile.actualPosition {
                return false
            }
        }
        return true
    }
}

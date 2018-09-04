//
//  TilePosition.swift
//  TileGame
//
//  Created by MCC on 15/4/18.
//  Copyright © 2018 Tejesh Alimilli. All rights reserved.
//

import Foundation

struct TilePosition: Equatable, CustomStringConvertible {
    var row = 0
    var column = 0
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    init(indexPath: IndexPath) {
        row = indexPath.section
        column = indexPath.row
    }
    
    var indexPath: IndexPath {
        return IndexPath(row: column, section: row)
    }
    
    var description: String {
        return "row \(row) column \(column)"
    }
}

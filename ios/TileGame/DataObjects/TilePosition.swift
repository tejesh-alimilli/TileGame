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
    
    var indexPath: IndexPath {
        return IndexPath(row: row, section: column)
    }
    
    var description: String {
        return "row \(row) column \(column)"
    }
}

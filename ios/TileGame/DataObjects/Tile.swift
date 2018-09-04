//
//  Tile.swift
//  TileGame
//
//  Created by MCC on 13/4/18.
//  Copyright © 2018 Tejesh Alimilli. All rights reserved.
//

import Foundation

class Tile: CustomStringConvertible {
    let actualPosition: TilePosition
    var currentPosition: TilePosition
    
    let content: Int?
    
    var isEmpty: Bool {
        return content == nil
    }
    
    var description: String {
        let contentString: String
        if let content = content {
            contentString = "\(content)"
        } else {
            contentString = "Empty Tile"
        }
        return "\(contentString) was at \(actualPosition), now at \(currentPosition)"
    }
    
    init(initPosition: TilePosition, content: Int?) {
        actualPosition = initPosition
        currentPosition = initPosition
        
        self.content = content
    }
}

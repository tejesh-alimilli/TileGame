//
//  TileView.swift
//  TileGame
//
//  Created by MCC on 13/4/18.
//  Copyright © 2018 Tejesh Alimilli. All rights reserved.
//

import UIKit

class TileView: UICollectionViewCell {
    @IBOutlet var tileContentLabel: UILabel!
    
    var tile: Tile? {
        didSet {
            if let content = tile?.content {
                tileContentLabel.text = "\(content)"
            } else {
                tileContentLabel.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundView?.layer.cornerRadius = 10
    }
}

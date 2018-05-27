//
//  ViewController.swift
//  TileGame
//
//  Created by MCC on 13/4/18.
//  Copyright © 2018 Tejesh Alimilli. All rights reserved.
//

import UIKit

let BoardRowsCount = 4
let BoardColsCount = 4

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var tileBoardCollectionView: UICollectionView!
    @IBOutlet var collectionViewParentView: UIView!
    
    @IBOutlet var winningMessageLabel: UILabel!
    @IBOutlet var movesLabel: UILabel!
    
    var tileBoard = TileBoard(rows: BoardRowsCount, cols: BoardColsCount)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTileBoardLayoutCalculation()
        tileBoardCollectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        weak var weakSelf = self
        coordinator.animateAlongsideTransition(in: view, animation: {(transitionCoordinatorContext) -> Void in
            weakSelf?.updateTileBoardLayoutCalculation()
            weakSelf?.tileBoardCollectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startNewGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateTileBoardLayoutCalculation()
        tileBoardCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTileBoardLayoutCalculation() {
        let layout = (tileBoardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        let leftSpacing = layout.sectionInset.left
        let rightSpacing = layout.sectionInset.right
        let totalSpacing = (CGFloat(BoardColsCount - 1) * (leftSpacing + rightSpacing))
        let tileWidth = (collectionViewParentView.frame.width - totalSpacing) / CGFloat(BoardColsCount)
        layout.itemSize = CGSize(width: tileWidth, height: tileWidth)
    }
    
    func startNewGame() {
        let movements = tileBoard.shuffle()
        tileBoardCollectionView.performBatchUpdates({
            for movement in movements {
                let movedFrom = movement.from.indexPath
                let movedTo = movement.to.indexPath
                tileBoardCollectionView.moveItem(at: movedFrom, to: movedTo)
            }
        }, completion: nil)
        winningMessageLabel.isHidden = true
        movesLabel.text = "\(tileBoard.movesCount)"
    }
    
    //MARK: collection view methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return BoardColsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BoardRowsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tileBoardCollectionView.dequeueReusableCell(withReuseIdentifier: "TileView", for: indexPath) as! TileView
        
        cell.tile = tileBoard.tileAt(row: indexPath.row, col: indexPath.section)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return tileBoard.canMoveTile(at: TilePosition(row: indexPath.row, column: indexPath.section))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        weak var weakSelf = self
        
        tileBoardCollectionView.allowsSelection = false
        
        let movements = tileBoard.moveTile(at: TilePosition(row: indexPath.row, column: indexPath.section))
        if movements.isEmpty {
            return
        }
        
        tileBoardCollectionView.performBatchUpdates({
            for movement in movements {
                let movedFrom = movement.from.indexPath
                let movedTo = movement.to.indexPath
                tileBoardCollectionView.moveItem(at: movedFrom, to: movedTo)
            }
        }, completion: { (flag: Bool) in
            weakSelf?.tileBoardCollectionView.allowsSelection = true
            
            if let completed = weakSelf?.tileBoard.isComplete() {
                weakSelf?.winningMessageLabel.isHidden = !completed
            }
        })
        
        movesLabel?.text = "\(tileBoard.movesCount)"
    }
    
    //MARK: ib actions
    @IBAction func startNewButtonClicked() {
        startNewGame()
    }
}

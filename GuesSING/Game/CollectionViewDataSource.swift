//
//  CollectionViewDataSource.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/11/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController: UICollectionViewDataSource, GetButtonPress {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Making the collection view cards for the amount of packages in FIrestore.
        
        var packCount = Int()
        
        if section == 0 {
            packCount = myDecks.count
        }
//        else if section == 1 {
//            packCount = decksToPurchase.count
//        }
//        else if section == 2 {
//            packCount = purchasePacks.count
//        }
        return packCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "DeckCell", for: indexPath) as! DeckCollectionViewCell
        
//        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "DeckCell2", for: indexPath) as! CreateDeckCollectionViewCell
        
        let section = indexPath.section
        
        if section == 0 {
            // Setting up the objects at each collection view card.
            cell1.deck = myDecks[indexPath.item]
            cell1.deckIndex = phrases?[indexPath.item]
            cell1.delegate = self
            cell = cell1
            //end of section 0
        }
//        else if section == 1 {
//            cell1.deck = purchasedArray[indexPath.item]
//            cell1.categoryindex = [indexPath.item].deckPhrases
//            cell1.delegate = self
//            cell = cell1
//            //cell = cell2
//        }
//        else if section == 2 {
//            cell2.deck3 = purchasePacks[indexPath.item]
//            cell2.index = indexPath.item
//            cell2.delegate = self
//            cell = cell2
//        }
        return cell
    }
    
    // Passing over the collection view item object that is selected by the user.
    @objc func getButtonPress(choosenDeck: [String], index: Int) {
        let gameBoardViewController = storyboard?.instantiateViewController(withIdentifier: "gameBoardViewController") as! GameBoardViewController
        gameBoardViewController.deckArray = choosenDeck
        gameBoardViewController.difficulty = index
        present(gameBoardViewController, animated: true, completion: nil)
    }

}


//
//  CollectionViewDelegate.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/11/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController : UICollectionViewDelegate {
    
    // Creating the delegate and scroll view for the collection.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

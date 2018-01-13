//
//  CreateDeckCollectionViewCell.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/16/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import UIKit

class CreateDeckCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var purchasePackLbl: UILabel!
    @IBOutlet weak var purchaseBtn: UIButton!
    @IBOutlet weak var view: UIView!
    
    var delegate: getIndex?
    var index: Int?
    var categoryindexSection2: [String]?
    
    var deck3: Deck? {
        didSet {
            self.updateSectionUI()
        }
    }
    
    private func updateSectionUI() {
        
        if let purchasePack = deck3 {
            
            let image = UIImage(named: (purchasePack.deckImage))
            backgroundImageView.image = image
            purchasePackLbl.text = purchasePack.deckName
        } else {
            backgroundImageView.image = nil
            purchasePackLbl.text = nil
        }
    }
    
    @IBAction func purchaseBtnTapped(_ sender: UIButton) {
        print(index!)
        delegate?.purchased(index: index!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        view.layer.cornerRadius = 15
        backgroundImageView.layer.cornerRadius = 15
        backgroundImageView.clipsToBounds = true
        purchaseBtn.layer.cornerRadius = 5
    }
}

protocol getIndex {
    func purchased(index:Int)
}

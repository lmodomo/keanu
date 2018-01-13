//
//  DeckCollectionViewCell.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/14/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import UIKit

class DeckCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deckImageView: UIImageView!
    @IBOutlet weak var deckNameLbl: UILabel!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    
    // Variables.
    @objc var deckIndex:[String]?
    var delegate:GetButtonPress?
    //let color = UIColor.randomColor()
    
    var deck: Deck? {
        didSet {
            self.updateUI()
            self.buttonSetup()
        }
    }
    
    private func buttonSetup() {
        
        // Setting up the medium button.
        mediumBtn.backgroundColor = .white
        mediumBtn.layer.cornerRadius = 5
        mediumBtn.tag = 0
        mediumBtn.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
        
        // Setting up the hard button.
        hardBtn.layer.cornerRadius = 5
        hardBtn.tag = 1
        hardBtn.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
    }
    
    @objc func handleButtonPress(sender:UIButton) {
        delegate?.getButtonPress(choosenDeck: deckIndex!, index: sender.tag)
    }
    
    private func updateUI() {
        
        if let mydecks = deck {
            let image = UIImage(named: mydecks.deckImage)
            deckImageView.image = image
            deckNameLbl.text = mydecks.deckName
        } else {
            deckImageView.image = nil
            deckNameLbl.text = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        deckImageView.layer.cornerRadius = 15
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 10, height: 20)
        self.clipsToBounds = false
    }
}

protocol GetButtonPress {
    func getButtonPress(choosenDeck:[String], index:Int)
}

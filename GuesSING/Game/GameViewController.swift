//
//  GameViewController.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/8/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import UIKit
import Firebase

class GameViewController: UIViewController, getIndex {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var db: Firestore!
    
    var decks = [Deck]()
    var myDecks = [Deck]()
    var decksToPurchase = [Deck]()
    var purchasedArray = [Deck]()
    
    var phrases:[[String]]?
    @objc var index: Int = 0
    
    // Getting the cell to scale the collectionView correctly
    @objc let cellScaling: CGFloat = 0.6

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        phrases = [[String]]()
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db.collection("decks").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.decks = querySnapshot!.documents.flatMap({Deck(dictionary: $0.data())})
                for i in self.decks {
                    print(i.deckName!)
                    print(i.deckImage)
                    print(i.deckPhrases!)
                    print(i.deckStatus)
                    print(i.deckTimeStamp)
                    
                    if i.deckStatus {
                        // Added this information of the items into the empty array called people.
                        self.myDecks.append(Deck(deckName: i.deckName, deckImage: i.deckImage, deckPhrases: i.deckPhrases, deckStatus: i.deckStatus, deckTimeStamp: i.deckTimeStamp))
                    } else {
                        self.decksToPurchase.append(Deck(deckName: i.deckName, deckImage: i.deckImage, deckPhrases: i.deckPhrases, deckStatus: i.deckStatus, deckTimeStamp: i.deckTimeStamp))
                    }
                    self.phrases?.append(i.deckPhrases!)
                }
            }
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionViewSetup()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func collectionViewSetup() {
        
        print("status true: \(myDecks.count)")
        print("status false: \(decksToPurchase.count)")
    
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        // Tell the collectionview where the datasource is.
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    
    func purchased(index:Int) {
        // This is where all the in app purchasing stuff is going to happen.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

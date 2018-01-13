//
//  Deck.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/11/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Deck {
    
    var deckName: String?
    var deckImage: String
    var deckPhrases: [String]?
    var deckStatus: Bool
    var deckTimeStamp: Date
    
    var dictionary:[String:Any] {
        return ["deckName":deckName!, "deckImage":deckImage, "deckPhrases":deckPhrases!, "deckStatus":deckStatus, "deckTimeStamp":deckTimeStamp]
    }
}

extension Deck : DocumentSerializable {
    init?(dictionary: [String:Any]) {
        guard
            let name = dictionary["deckName"] as? String,
            let image = dictionary["deckImage"] as? String,
            let phrases = dictionary["deckPhrases"] as? [String],
            let status = dictionary["deckStatus"] as? Bool,
            let timeStamp = dictionary["deckTimeStamp"] as? Date
        else {
            return nil
        }
        self.init(deckName: name, deckImage: image, deckPhrases: phrases, deckStatus: status, deckTimeStamp:timeStamp)
    }
}


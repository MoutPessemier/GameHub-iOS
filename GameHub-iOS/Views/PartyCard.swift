//
//  PartyCard.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import MaterialComponents
    
class PartyCard: MDCCard {
    
    // var party: Party = Party(id: nil, name: "", date: Date(), maxSize: 4, participants: [], gameId: "", coordinates: [], declines: [])
    // var game: Game = Game(id: nil, name: "", description: "", rules: "", requirements: "", type: .BOARD_GAME)
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.frame = CGRect(x: 20, y: 20, width: 300, height: 500)
        
        let partyName = UILabel()
        partyName.frame = CGRect(x: 0, y: 8, width: 300, height: 50)
        self.addSubview(partyName)
        
        let gameName = UILabel()
        partyName.frame = CGRect(x: 0, y: 66, width: 300, height: 50)
        self.addSubview(gameName)
        
        let gameDescription = UILabel()
        partyName.frame = CGRect(x: 0, y: 124, width: 300, height: 100)
        self.addSubview(gameDescription)
        
        let partyWhen = UILabel()
        partyName.frame = CGRect(x: 0, y: 232, width: 300, height: 50)
        self.addSubview(partyWhen)
        
    }

}

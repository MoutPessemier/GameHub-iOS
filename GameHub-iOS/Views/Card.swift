//
//  Card.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 06/12/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import Material

class CardView: UIView {
    private let sideContraint: CGFloat = 8.0
    private var card = Card()
    private var party: Party
    
    init(frame: CGRect, party: Party) {
        self.party = party
        super.init(frame: frame)
        let contentView = UIView(frame: frame)
        
        let lblName = UILabel()
        lblName.text = "test name"
        lblName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblName)
        contentView.addConstraints([
            lblName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint),
            lblName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: sideContraint)
        ])
        
        let lblGameName = UILabel()
        lblGameName.text = "test game"
        lblGameName.translatesAutoresizingMaskIntoConstraints = false
        
        lblGameName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint)
        lblGameName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: sideContraint)
        contentView.addSubview(lblGameName)
        
        let lblPartyDate = UILabel()
        lblPartyDate.text = "test date"
        lblPartyDate.translatesAutoresizingMaskIntoConstraints = false
        
        lblPartyDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint)
        lblPartyDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: sideContraint)
        contentView.addSubview(lblPartyDate)
        
        let lblPartyWhere = UILabel()
        lblPartyWhere.text = "test location"
        lblPartyWhere.translatesAutoresizingMaskIntoConstraints = false
        
        lblPartyWhere.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint)
        lblPartyWhere.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: sideContraint)
        contentView.addSubview(lblPartyWhere)
        
        card.contentView = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

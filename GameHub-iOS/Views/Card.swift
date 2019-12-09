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
        
        // these are test labels that later on will be filled with real data
        // I want these to take up the whole width of the contentView with left and right margins of 8
        // I know I have not contrained these to the top or bottom, that'll follow once I understand how contraints work
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
        contentView.addSubview(lblGameName)
        contentView.addConstraints([
            lblGameName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint),
            lblGameName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: sideContraint)
        ])
        
        let lblPartyDate = UILabel()
        lblPartyDate.text = "test date"
        lblPartyDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblPartyDate)
        contentView.addConstraints([
            lblPartyDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint),
            lblPartyDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: sideContraint)
        ])
        
        let lblPartyWhere = UILabel()
        lblPartyWhere.text = "test location"
        lblPartyWhere.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblPartyWhere)
        contentView.addConstraints([
            lblPartyWhere.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint),
            lblPartyWhere.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: sideContraint)
        ])
        
        card.contentView = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

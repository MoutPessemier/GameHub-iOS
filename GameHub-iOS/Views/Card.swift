//
//  Card.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 06/12/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit

class CardView: UIView {
    private let sideContraint: CGFloat = 16.0
    private let topConstraint: CGFloat = 32.0
    private let textSizeTitle: CGFloat = 32.0
    private let textSizeNormal: CGFloat = 24.0
    private let textSizeDescription: CGFloat = 20.0
    
    private var party: Party
    private var game: Game
    
    init(frame: CGRect, party: Party, game: Game) {
        self.party = party
        self.game = game
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 500))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = .init(width: 0, height: 5)
        contentView.layer.shadowRadius = 5
        
        let lblName = UILabel()
        lblName.text = party.name
        lblName.textAlignment = .center
        lblName.font = UIFont.systemFont(ofSize: textSizeTitle)
        lblName.numberOfLines = 0
        
        lblName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblName)
        contentView.addConstraints([
            lblName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint),
            lblName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sideContraint),
            lblName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topConstraint)
        ])
        
        let lblGameName = UILabel()
        lblGameName.text = game.name
        lblGameName.textAlignment = .center
         lblGameName.font = UIFont.systemFont(ofSize: textSizeNormal)
        
        lblGameName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblGameName)
        contentView.addConstraints([
            lblGameName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint),
            lblGameName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sideContraint),
            lblGameName.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: topConstraint * 2)
        ])
        
        let lblGameDescription = UILabel()
        lblGameDescription.text = game.description
        lblGameDescription.textAlignment = .center
         lblGameDescription.font = UIFont.systemFont(ofSize: textSizeDescription)
        lblGameDescription.lineBreakMode = .byWordWrapping
        lblGameDescription.numberOfLines = 0
        
        lblGameDescription.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblGameDescription)
        contentView.addConstraints([
            lblGameDescription.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint),
            lblGameDescription.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sideContraint),
            lblGameDescription.topAnchor.constraint(equalTo: lblGameName.bottomAnchor, constant: topConstraint * 2)
        ])
        
        let lblPartyDate = UILabel()
        lblPartyDate.text = String(party.date.iso8601.split { $0 == "T" }[0]).replacingOccurrences(of: "-", with: "/")
        lblPartyDate.textAlignment = .center
         lblPartyDate.font = UIFont.systemFont(ofSize: textSizeNormal)
        
        lblPartyDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblPartyDate)
        contentView.addConstraints([
            lblPartyDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideContraint),
            lblPartyDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sideContraint),
            lblPartyDate.topAnchor.constraint(equalTo: lblGameDescription.bottomAnchor, constant: topConstraint * 2)
        ])
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

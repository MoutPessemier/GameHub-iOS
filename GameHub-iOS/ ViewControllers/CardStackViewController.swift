//
//  CardStackViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import CoreLocation
import Lottie
import Koloda

class CardStackViewController: UIViewController, CLLocationManagerDelegate, NetworkManagerDelegate {
    
    private var networkManager: NetworkManager = NetworkManager()
    private let locationManager = CLLocationManager()
    private let loggedInUser = SessionManager.shared.user!
    private var games: [Game] = []
    private var parties: [Party] = []
    private var currentParty: Party? = nil
    
    @IBOutlet private var stackView: KolodaView!
    @IBOutlet private var animationView: AnimationView!
    @IBOutlet var lblNoParties: UILabel!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.dataSource = self
        stackView.delegate = self
        networkManager.delegate = self
        networkManager.getGames()
        lblNoParties.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentLocation()
        if let animation = Animation.named("loading_infinity") {
            animationView.animation = animation
            animationView.loopMode = .loop
            animationView.play()
        }
    }
    
    //MARK: - Location
    func getCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        networkManager.getPartiesNearYou(maxDistance: 100, userId: loggedInUser.id!, latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("---LOCATIONMANAGER DID FAIL @ CARDSTACK---", error.localizedDescription)
    }
    
    // MARK: - NetworkDelegate
    func updateGames(_ networkManager: NetworkManager, _ games: [Game]) {
        self.games = games
    }
    
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party]) {
        self.parties = parties
        DispatchQueue.main.async {
            self.animationView.animation = nil
            self.animationView.isHidden = true
            self.stackView.reloadData()
        }
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func doesUserExist(_ networkManager: NetworkManager, _ userExists: Bool) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func didFail(with error: Error) {
        DispatchQueue.main.async {
            if let animation = Animation.named("error") {
                self.animationView.isHidden = false
                self.animationView.animation = animation
                self.animationView.loopMode = .repeat(3.0)
                self.animationView.play { (finished) in
                    self.animationView.stop()
                    self.animationView.isHidden = true
                }
                
            }
            
        }
        print("---DIDFAIL WITH ERROR @ CARDSTACK---", error, error.localizedDescription)
    }
    
    // MARK: - Swipe
    @IBAction func swipeRight(_ sender: Any) {
        stackView.swipe(.right)
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        stackView.swipe(.left)
    }
}

// MARK: - KolodaView Delegate
extension CardStackViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        lblNoParties.isHidden = false
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("---DIDSELECTCARDAT---", index)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let currentParty = parties[index]
        if direction == .left {
            networkManager.declineParty(partyId: currentParty.id!, userId: loggedInUser.id!)
        } else if direction == .right {
            networkManager.joinParty(partyId: currentParty.id!, userId: loggedInUser.id!)
        }
    }
}

// MARK: - KolodaView DataSource
extension CardStackViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return parties.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let party = parties[index]
        let game = games.first {
            g in g.id == party.gameId
        }
        currentParty = party
        let sideContraint: CGFloat = 16.0
        let topConstraint: CGFloat = 32.0
        let textSizeTitle: CGFloat = 32.0
        let textSizeNormal: CGFloat = 24.0
        let textSizeDescription: CGFloat = 20.0
        
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
        lblGameName.text = game?.name
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
        lblGameDescription.text = game?.description
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
        
        return contentView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return SwipeOverlay()
    }
}


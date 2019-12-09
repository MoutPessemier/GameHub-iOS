//
//  CardStackViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import Auth0
import CoreLocation
import Lottie
import Loaf
import Koloda

class CardStackViewController: UIViewController, CLLocationManagerDelegate, NetworkManagerDelegate {
    
    private var networkManager: NetworkManager = NetworkManager()
    private var games: [Game] = []
    private var parties: [Party] = []
    private var user: User? = nil
    private let locationManager = CLLocationManager()
    @IBOutlet private var stackView: KolodaView!
    @IBOutlet private var animationView: AnimationView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.dataSource = self
        stackView.delegate = self
        networkManager.delegate = self
        networkManager.getGames()
        networkManager.getUser(email: "moutpessemier@hotmail.com")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentLocation()
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
        networkManager.getPartiesNearYou(maxDistance: 10, userId: "5decc1fa600ecf25c1e0433e", latitude: locValue.latitude, longitude: locValue.longitude)
        // mock request 5db8838eaffe445c66076a88
        // networkManager.getPartiesNearYou(maxDistance: 10, userId: "5decc1fa600ecf25c1e0433e", latitude: 50.92, longitude: 4.06)
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
            self.stackView.reloadData()
        }
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        self.user = user
    }
    
    func didFail(with error: Error) {
        DispatchQueue.main.async {
            if let animation = Animation.named("error", subdirectory: "Animations") {
                self.animationView.isHidden = false
                self.animationView.animation = animation
                self.animationView.loopMode = .loop
                self.animationView.play()
            }
        }
        print("---DIDFAIL WITH ERROR @ CARDSTACK---", error.localizedDescription)
    }
    
    // MARK: - Swipe
    
    @IBAction func swipeRight(_ sender: Any) {
        stackView.swipe(.left)
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        stackView.swipe(.right)
    }
}

// MARK: - KolodaView Delegate
extension CardStackViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
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
        return CardView(frame: CGRect.init(x: 0, y: 0, width: 350, height: 500), party: parties[index])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return SwipeOverlay()
    }
}


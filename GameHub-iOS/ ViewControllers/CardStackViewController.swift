//
//  CardStackViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import Auth0
import MapKit
import CoreLocation
import Lottie
import Loaf

class CardStackViewController: UIViewController, CLLocationManagerDelegate, NetworkManagerDelegate {
    
    private var networkManager: NetworkManager = NetworkManager()
    private var games: [Game] = []
    private var parties: [Party] = []
    private var user: User? = nil
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        networkManager.getGames()
        networkManager.getUser(email: "moutpessemier@hotmail.com")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentLocation()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
        //networkManager.getPartiesNearYou(maxDistance: 10, userId: "5db8838eaffe445c66076a89", latitude: locValue.latitude, longitude: locValue.longitude)
        // mock request
        networkManager.getPartiesNearYou(maxDistance: 10, userId: "5db8838eaffe445c66076a89", latitude: 50.92, longitude: 4.06)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    // MARK: - NetworkDelegate
    func updateGames(_ networkManager: NetworkManager, _ games: [Game]) {
        self.games = games
    }
    
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party]) {
        self.parties = parties
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        self.user = user
    }
    
    func didFail(with error: Error) {
//        let errorAnimationView = AnimationView(filePath: "error.json")
//        errorAnimationView.play()
        print("---ERROR---", error.localizedDescription)
    }
    
}


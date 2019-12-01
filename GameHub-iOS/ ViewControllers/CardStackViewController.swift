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

class CardStackViewController: UIViewController, CLLocationManagerDelegate {
    
    private var networkManager: NetworkManager = NetworkManager()
    private var games: [Game] = []
    private var parties: [Party] = []
    private var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        games = networkManager.getGames()
        parties = networkManager.getPartiesNearYou(maxDistance: 10, userId: "5db8838eaffe445c66076a89", latitude: 51.05, longitude: 3.72)
        user = networkManager.getUser(email: "moutpessemier@hotmail.com")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
//    override var shouldAutorotate: Bool {
//        return true
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("test")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

}

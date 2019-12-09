//
//  MapViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 01/12/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import MapKit
import Lottie

class MapViewController: UIViewController, CLLocationManagerDelegate, NetworkManagerDelegate, MKMapViewDelegate {
    
    private var networkManager: NetworkManager = NetworkManager()
    private var parties: [Party] = []
    @IBOutlet var map: MKMapView!
    private let radius: CLLocationDistance = 30000
    let locationManager = CLLocationManager()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        map.delegate = self
        getCurrentLocation()
    }
    
    // MARK: - Map
    func centerMap(_ location: CLLocation) {
        map.showsUserLocation = true
        map.setCenter(location.coordinate, animated: true)
        map.setCamera(.init(lookingAtCenter: location.coordinate, fromEyeCoordinate: location.coordinate, eyeAltitude: location.altitude), animated: true)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        map.setRegion(region, animated: true)
    }
    
    private func annotateMap() {
        parties.forEach { (party) in
            let annotation = MKPointAnnotation()
            annotation.title = party.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: party.location.coordinates[0], longitude: party.location.coordinates[1])
            map.addAnnotation(annotation)
        }
    }
    
    // MARK: - Location
    private func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        centerMap(currentLocation)
        networkManager.getPartiesNearYou(maxDistance: 10, userId: "5decc1fa600ecf25c1e0433e", latitude: locValue.latitude, longitude: locValue.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("---LOCATIONMANAGER DID FAIL---", error.localizedDescription)
    }
    
    // MARK: - Network Delegate
    
    func updateGames(_ networkManager: NetworkManager, _ games: [Game]) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party]) {
        self.parties = parties
        DispatchQueue.main.async {
            self.annotateMap()
        }
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func didFail(with error: Error) {
        print("---DIDFAIL WITH ERROR @ MAPVIEW---", error.localizedDescription, error)
    }
}

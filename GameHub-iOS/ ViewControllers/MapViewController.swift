//
//  MapViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 01/12/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, NetworkManagerDelegate, MKMapViewDelegate {

    private var networkManager: NetworkManager = NetworkManager()
    private var parties: [Party] = []
    @IBOutlet var map: MKMapView!
    private var currentLocation: CLLocation? = nil
    private let radius: CLLocationDistance = 100
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        map.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentLocation()
        guard let safeLocation = currentLocation else { return print("---TEST---") }
        print("---LOCATION---", safeLocation)
        centerMap(safeLocation)
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - Map
    func centerMap(_ location: CLLocation) {
                map.showsUserLocation = true
        map.setCenter(location.coordinate, animated: true)
        map.setCamera(.init(lookingAtCenter: location.coordinate, fromEyeCoordinate: location.coordinate, eyeAltitude: location.altitude), animated: true)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        map.setRegion(region, animated: true)
        annotateMap()
    }
    
    func annotateMap() {
        parties.forEach { (party) in
            let annotation = MKPointAnnotation()
            annotation.title = party.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: party.location.coordinates[0], longitude: party.location.coordinates[1])
            map.addAnnotation(annotation)
        }
    }
    
    // MARK: - Location
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
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        //networkManager.getPartiesNearYou(maxDistance: 10, userId: "5db8838eaffe445c66076a89", latitude: locValue.latitude, longitude: locValue.longitude)
        networkManager.getPartiesNearYou(maxDistance: 10, userId: "5db8838eaffe445c66076a89", latitude: 51.05, longitude: 3.72)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    // MARK: - Delegate
    
    func updateGames(_ networkManager: NetworkManager, _ games: [Game]) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party]) {
        self.parties = parties
        annotateMap()
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func didFail(with error: Error) {
        
    }
}

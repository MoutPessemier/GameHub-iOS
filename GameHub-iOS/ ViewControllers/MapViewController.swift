//
//  MapViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 01/12/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    private let networkManager: NetworkManager = NetworkManager()
    private var parties: [Party] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        parties = networkManager.getPartiesNearYou(maxDistance: 10, userId: "5db8838eaffe445c66076a89", latitude: 51.05, longitude: 3.72)
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 51.05, longitude: 3.72, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//        placeMarkersOnMap(map: mapView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func placeMarkersOnMap(map: GMSMapView) {
        parties.forEach { (party) in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: party.location.coordinates[0], longitude: party.location.coordinates[1])
            marker.title = party.name
            marker.map = map
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("test")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

//    override var shouldAutorotate: Bool {
//        return false
//    }

}

//
//  LocationManager.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import Foundation
import CoreLocation

// MARK: - Protocols
protocol Locationable {
    func requestLocationPermission()
}
protocol LocationDelegate {
    func didUpdateLocation(to newTownName: String?)
    func didNotAllowedLocationPermission()
}


// MARK: - Location Manager
class LocationManager: NSObject {
    //MARK: Variables
    // TODO: Do it with RX
    private var exposedLocation: CLLocation? {
        didSet {
            guard let exposedLocation = exposedLocation else { return}
            locationConvertor.getTownName(location: exposedLocation) {
                [unowned self]
                (townName) in
                self.delegate?.didUpdateLocation(to: townName)
            }
        }
    }
    private let locationManager = CLLocationManager()
    private let locationConvertor = LocationConvertor()
    var delegate: LocationDelegate?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
}

// MARK: - Locationable
extension LocationManager: Locationable {
    func requestLocationPermission() {
        self.locationManager.requestAlwaysAuthorization()
    }
}

// MARK: - Core Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            self.exposedLocation = locations[0]
        }
    }
    
    // It executes automatically
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        // TODO: Handle different permission states
        switch status {
        
        case .notDetermined:
            print("Not determined!")
            requestLocationPermission()
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location permission allowed!")
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            delegate?.didNotAllowedLocationPermission()
            
        @unknown default:
            fatalError("Unknow location permission")
        }
    }
}




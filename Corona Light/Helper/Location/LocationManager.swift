//
//  LocationManager.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import Foundation
import CoreLocation


protocol Locationable {
    func requestLocationPermission()
}
protocol LocationDelegate {
    func didUpdateLocation(to state: String)
    func didNotAllowedLocationPermission()
}


class LocationManager: NSObject {
    
    //MARK: Variables
    private var exposedLocation: CLLocation?
    private let locationManager = CLLocationManager()
    var delegate: LocationDelegate?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
}
extension LocationManager: Locationable {
    func requestLocationPermission() {
        self.locationManager.requestAlwaysAuthorization()
    }
}

// MARK: - Core Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        print("Location Updated to: \(locations)\n")
        self.exposedLocation = locations[0]
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
            
        case .restricted, .denied:
            delegate?.didNotAllowedLocationPermission()
            
        @unknown default:
            fatalError("Unknow location permission")
        }
    }
}

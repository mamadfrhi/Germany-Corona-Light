//
//  LocationManager.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import CoreLocation
import RxSwift

// MARK: - Protocols
protocol Locationable {
    func startUpdatingLocation()
    func getLocationInfo() -> LocationInfo?
}
protocol LocationDelegate {
    func didUpdateLocation(to newLocation: LocationInfo?)
    func didNotAllowedLocationServices()
}


// MARK: - Location Manager
class LocationManager: NSObject {
    
    // MARK: Variables
    private var locationInfo: LocationInfo?
    private let locationManager = CLLocationManager()
    var delegate: LocationDelegate?
    
    // RX
    let exposedLocation: PublishSubject<CLLocation?> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        setupBinding()
        self.locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    private func setupBinding() {
        // Convert location to sensible Model and call delegate
        exposedLocation.bind {
            (freshLocation) in
            guard let exposedLocation = freshLocation else { return}
            self.locationInfo = LocationInfo(clLocation: exposedLocation)
            // call delegate
            self.delegate?.didUpdateLocation(to: self.locationInfo!)
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Locationable
extension LocationManager: Locationable {
    func getLocationInfo() -> LocationInfo? { self.locationInfo }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
}

// MARK: - Core Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let currentLocation = locations[0]
            self.exposedLocation.onNext(currentLocation)
        }
    }
    
    // It executes automatically
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            delegate?.didNotAllowedLocationServices()
            
        @unknown default:
            fatalError("Unknow location permission")
        }
    }
}

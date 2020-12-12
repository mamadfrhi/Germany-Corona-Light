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
    var locationInfo: LocationInfo? { get set}
    func requestLocationPermission()
    func startUpdatingLocation()
}
// Make optionals
extension Locationable {
    func requestLocationPermission() {}
    var locationInfo: LocationInfo? {
        get {
            return LocationInfo(country: nil, state: nil, town: nil)
        }
        set {
            return
        }
    }
}
protocol LocationDelegate {
    func didUpdateLocation(to newLocation: LocationInfo?)
    func didNotAllowedLocationServices()
}


// MARK: - Location Manager
class LocationManager: NSObject {
    
    // MARK: Variables
    private var localLocationInfo : LocationInfo?
    private let locationManager = CLLocationManager()
    private let locationConvertor = LocationAdapter()
    var delegate: LocationDelegate?
    
    // RX
    let exposedLocation: PublishSubject<CLLocation?> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        setupBinding()
        self.locationManager.delegate = self
    }
    
    private func setupBinding() {
        // Convert location to sensible Model and call delegate
        exposedLocation.bind {
            (freshLocation) in
            guard let exposedLocation = freshLocation else { return}
            self.locationConvertor.getLocationInfo(from: exposedLocation) {
                [unowned self]
                (locationInfo) in
                // set local locationInfo
                self.localLocationInfo = locationInfo
                // call delegate
                self.delegate?.didUpdateLocation(to: locationInfo)
            }
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Locationable
extension LocationManager: Locationable {
    var locationInfo: LocationInfo? {
        get {
            return localLocationInfo
        }
        set {
            self.localLocationInfo = newValue
        }
    }
    
    func requestLocationPermission() {
        self.locationManager.requestAlwaysAuthorization()
    }
    
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
            print("Not determined!")
            requestLocationPermission()
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location permission allowed!")
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            delegate?.didNotAllowedLocationServices()
            
        @unknown default:
            fatalError("Unknow location permission")
        }
    }
}

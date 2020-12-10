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
}
protocol LocationDelegate {
    func didUpdateLocation(to newLocation: LocationInfo?)
    func didNotAllowedLocationPermission()
}


// MARK: - Location Manager
class LocationManager: NSObject {
    
    // MARK: Variables
    private var localLocationInfo : LocationInfo?
    private let locationManager = CLLocationManager()
    private let locationConvertor = LocationConvertor()
    var delegate: LocationDelegate?
    
    // RX
    let exposedLocation: PublishSubject<CLLocation?> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        setupBinding()
    }
    
    private func setupBinding() {
        // Convert location to sensible Model and call delegate
        exposedLocation.bind { (freshLocation) in
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




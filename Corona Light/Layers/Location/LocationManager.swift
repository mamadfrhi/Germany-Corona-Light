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
    var delegate: LocationDelegate? { get set }
}
extension Locationable { // make delegate optional
    var delegate: LocationDelegate? {
        get { nil }
        set { delegate = newValue }
    }
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
    private var _delegate: LocationDelegate?
    var delegate: LocationDelegate? {
        get {
            return self._delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    // RX
    private let exposedLocation: PublishSubject<CLLocation?> = PublishSubject()
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
            LocationInfo(clLocation: exposedLocation).get {
                [weak self] in
                self?.locationInfo = $0
                self?._delegate?.didUpdateLocation(to: $0)
            }
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
            _delegate?.didNotAllowedLocationServices()
        @unknown default:
            fatalError("Unknow location permission")
        }
    }
}

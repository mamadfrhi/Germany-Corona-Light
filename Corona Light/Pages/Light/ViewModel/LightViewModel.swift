//
//  LightViewModel.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import Foundation

class LightViewModel {
    
    //MARK:- Dependencies
    private let network: Networkable!
    private let locationManager: LocationManager!
    
    // Inject -> network + location manager + notification
    init(network: Networkable, locationManager: LocationManager) {
        self.network = network
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }
}

//MARK:- Location
extension LightViewModel: LocationDelegate {
    func didUpdateLocation(to state: String) {
        print("Did update location at this state: \(state).\n")
    }
    func didNotAllowedLocationPermission() {
        print("I can't help you without location permission")
        // TODO: send user to the settings app to enable location permission
    }
}

//MARK:- Network
extension LightViewModel: Networkable, NetworkDelegate {
    func getStats(of state: String) {
        
    }
    func didGetStats(numberOfDeath: Int) {
        
    }
}

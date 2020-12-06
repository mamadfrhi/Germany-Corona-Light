//
//  LightViewModel.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import Foundation
import Moya
import SwiftyJSON

class LightViewModel {
    
    //MARK: Dependencies
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
    func didUpdateLocation(to newStateName: String?) {
        print("Did update location at this town: \(String(describing: newStateName)).\n")
        network.getStats(of: newStateName!) {
            (incidents) in
            print("incidents of \(newStateName!) = \(incidents!)")
        }
    }
    func didNotAllowedLocationPermission() {
        print("I can't help you without location permission")
        // TODO: send user to the settings app to enable location permission
    }
}

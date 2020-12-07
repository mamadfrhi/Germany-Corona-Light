//
//  LightViewModel.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class LightViewModel {
    
    //MARK: Dependencies
    private let network: Networkable
    private let locationManager: LocationManager
    
    // Inject -> network + location manager + notification
    init(network: Networkable, locationManager: LocationManager) {
        self.network = network
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }
    
    //MARK: RX
    let loading: PublishSubject<Bool> = PublishSubject()
    let errorMessage : PublishSubject<String> = PublishSubject()
    var stateStatus : PublishSubject<LightColors> = PublishSubject()
    
    private let disposeable = DisposeBag()
}

//MARK:- Location
extension LightViewModel: LocationDelegate {
    func didUpdateLocation(to newStateName: String?) {
        print("Did update location at this town: \(String(describing: newStateName)).\n")
        guard let stateName = newStateName else {
            self.errorMessage.onNext("I can't detect your location!")
            return
        }
        getIncidents(of: stateName)
    }
    
    private func getIncidents(of stateName: String) {
        // Start request
        loading.onNext(true)
        network.getStats(of: stateName) {
            [unowned self]
            (incidents, errorMessage) in
            // Stop loading
            self.loading.onNext(false)
            
            // Decide on result
            if let incidents = incidents {
                print("incidents of \(stateName) = \(String(describing: incidents))")
                setStateStatus(by: incidents)
            }else {
                // If incidents were nil
                // There is an error
                if let errorMessage = errorMessage {
                    self.errorMessage.onNext(errorMessage)
                }
            }
        }
    }
    
    private func setStateStatus(by incidents: Int) {
        // Green
        if incidents < 35 {
            self.stateStatus.onNext(.green)
        }
        // Yellow
        else if incidents >= 35 && incidents <= 50 {
            self.stateStatus.onNext(.yellow)
        }
        // Red
        else if incidents >= 35 && incidents <= 50 {
            self.stateStatus.onNext(.red)
        }
        // DarkRed
        else if incidents > 100 {
            self.stateStatus.onNext(.darkRed)
        }
    }
    
    func didNotAllowedLocationPermission() {
        print("I can't help you without location permission")
        // TODO: send user to the settings app to enable location permission
    }
}

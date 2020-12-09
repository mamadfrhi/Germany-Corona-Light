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
        setupRefreshTimer()
    }
    
    //MARK: RX
    let loading: PublishSubject<Bool> = PublishSubject()
    let errorMessage : PublishSubject<String> = PublishSubject()
    let townStatus : PublishSubject<LightColors> = PublishSubject()
    
    let locationInfo : PublishSubject<LocationInfo> = PublishSubject()

    private func setupRefreshTimer() {
        let tenMinutes = TimeInterval(10)
        Observable<Int>
            .timer(0, period: tenMinutes,
                   scheduler: MainScheduler.instance)
            .subscribe { _ in
                if let townName = self.locationManager.locationInfo?.town {
                    print("I'm going to refresh stats!")
                    self.getIncidents(of: townName)
                }
            }
            .disposed(by: disposeable)
    }
    
    private let disposeable = DisposeBag()
}

//MARK:- Location
extension LightViewModel: LocationDelegate {
    func didUpdateLocation(to locationInfo: LocationInfo?) {
        print("Did update location at this town: \(String(describing: locationInfo?.town)).\n")
        guard let locationInfo = locationInfo,
              let townName = locationInfo.town else {
            self.errorMessage.onNext("I can't detect your location!")
            return
        }
        self.locationInfo.onNext(locationInfo)
        getIncidents(of: townName)
    }
    
    private func getIncidents(of townName: String) {
        // Start request
        loading.onNext(true)
        network.getStats(of: townName) {
            [unowned self]
            (incidents, errorMessage) in
            // Stop loading
            self.loading.onNext(false)
            
            // Decide on result
            if let incidents = incidents {
                print("incidents of \(townName) = \(String(describing: incidents))")
                setTownStatus(by: incidents)
            }else {
                // If incidents were nil
                // There is an error
                if let errorMessage = errorMessage {
                    self.errorMessage.onNext(errorMessage)
                }
            }
        }
    }
    
    private func setTownStatus(by incidents: Int) {
        // Green
        if incidents < 35 {
            self.townStatus.onNext(.green)
        }
        // Yellow
        else if incidents >= 35 && incidents <= 50 {
            self.townStatus.onNext(.yellow)
        }
        // Red
        else if incidents >= 35 && incidents <= 50 {
            self.townStatus.onNext(.red)
        }
        // DarkRed
        else if incidents > 100 {
            self.townStatus.onNext(.darkRed)
        }
    }
    
    func didNotAllowedLocationPermission() {
        print("I can't help you without location permission")
        // TODO: send user to the settings app to enable location permission
    }
}

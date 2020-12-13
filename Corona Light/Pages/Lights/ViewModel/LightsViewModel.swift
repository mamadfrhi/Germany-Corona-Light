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

internal
class LightsViewModel {
    
    // MARK:- Dependencies
    
    private var api: CoronaNetworkable
    private let locationManager: Locationable
    private let notificationManager: Notificationable
    
    
    // Inject -> network + location manager + notification
    init(coronaNetworking: CoronaNetworkable,
         locationManager: LocationManager,
         notificationManager: Notificationable) {
        // Injecting dependencies
        self.api = coronaNetworking
        self.locationManager = locationManager
        self.notificationManager = notificationManager
        // Delegates conformation
        locationManager.delegate = self
        (coronaNetworking as? CoronaNetworking)?.delegate = self
        requestNotificationPermission()
        // setup RX related
        setupRefreshTimer()
        setupNotification()
    }
    
    
    // MARK:- Variables
    
    private var requestSentTime: Date?
    

    // MARK:- RX Variables
    
    // UI
    let loading: PublishSubject<Bool> = PublishSubject()
    let networkError : PublishSubject<NetworkError> = PublishSubject()
    let locationError : PublishSubject<LocationError> = PublishSubject()
    let notificationTapped : PublishSubject<Bool> = PublishSubject()
    
    // Logic
    let townStatus : PublishSubject<StatusColors> = PublishSubject()
    let locationInfo : PublishSubject<LocationInfo> = PublishSubject()
    
    private let disposeable = DisposeBag()
    

    // MARK:- RX Setups
    
    private func setupRefreshTimer() {
        let tenMinutes = TimeInterval(60 * 10)
        Observable<Int>
            .timer(0,
                   period: tenMinutes,
                   scheduler: MainScheduler.instance)
            .subscribe { _ in
                if let townName = self.locationManager.locationInfo?.town {
                    print("I'm going to refresh stats!")
                    self.getIncidents(of: townName, previousRequestTime: self.requestSentTime)
                }
            }
            .disposed(by: disposeable)
    }
    
    private func setupNotification() {
        // If townStatus changed -> SEND notification to user
        townStatus.currentAndPrevious()
            .subscribe { (current, previous) in
                guard let previous = previous else { return}
                if current != previous { // status changed
                    // send notification
                    self.sendLocalizedNotification(at: 1)
                }
            }
            .disposed(by: disposeable)
        
        
        // Check type of injected NotificationManager is safe
        guard let notificationManager = notificationManager as? NotificationManager
        else { return}
        // Notification button or banner TAPPED
        notificationManager.notificationTapped
            .subscribe { _ in
                print("Notif tapped! I'm in VM")
                // go to rules page
                self.notificationTapped.onNext(true)
            }
            .disposed(by: disposeable)
    }
    
    // Function
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
}

//MARK:-
//MARK: Location
//MARK:-

// Location Delegate
extension LightsViewModel: LocationDelegate {
    func didUpdateLocation(to locationInfo: LocationInfo?) {
        print("Did update location at this town: \(String(describing: locationInfo?.town)).\n")
        
        guard let locationInfo = locationInfo,
              let stateName = locationInfo.state,
              let townName = locationInfo.town else {
            self.locationError.onNext(.badLocationError)
            return
        }
        
        let localizedStateName = "stateName".localized()
        guard stateName == localizedStateName else {
            self.locationError.onNext(.outOfBavariaError)
            return
        }
        
        self.locationInfo.onNext(locationInfo)
        // Call API
        self.getIncidents(of: townName,
                          previousRequestTime: self.requestSentTime)
    }
    
    func didNotAllowedLocationServices() {
        locationError.onNext(.locationNotAllowedError)
    }
}

// Locationable
extension LightsViewModel: Locationable {
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}

//MARK:-
//MARK: Network
//MARK:-

// Corona Networkable
extension LightsViewModel: CoronaNetworkable {
    func getIncidents(of townName: String,
                      previousRequestTime: Date?) {
        self.api.getIncidents(of: townName,
                              previousRequestTime: previousRequestTime)
    }
    
    func retryRequest() {
        if let townName = self.locationManager.locationInfo?.town {
            let longTimeAgo = Date(timeIntervalSince1970: 1)
            self.getIncidents(of: townName,
                              previousRequestTime: longTimeAgo)
        }
    }
}

// Corona Networkable Delegate
extension LightsViewModel: CoronaNetworkableDelegate {
    func isLoading(loading: Bool) {
        self.loading.onNext(loading)
    }
    
    func raisedNetworkError(error: NetworkError) {
        self.networkError.onNext(error)
        // reset
        self.requestSentTime = Date()
    }
    
    func didGet(incidents: Int) {
        // Result
        setTownStatus(by: incidents)
        // reset
        self.requestSentTime = Date()
    }
}

//MARK:-
//MARK: Notification
//MARK:-

extension LightsViewModel: Notificationable {
    func requestNotificationPermission() {
        notificationManager.requestNotificationPermission()
    }
    
    func sendLocalizedNotification(at timetInterval: TimeInterval) {
        notificationManager.sendLocalizedNotification(at: timetInterval)
    }
}

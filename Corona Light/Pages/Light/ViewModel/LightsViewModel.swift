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

class LightsViewModel {
    
    // MARK: Dependencies
    private var api: CoronaNetworkable
    private let locationManager: LocationManager
    private let notificationManager: Notificationable
    
    // Inject -> network + location manager + notification
    init(network: CoronaNetworkable,
         locationManager: LocationManager,
         notificationManager: Notificationable) {
        // Injecting dependencies
        self.api = network
        self.locationManager = locationManager
        self.notificationManager = notificationManager
        locationManager.delegate = self
        (network as! CoronaNetworking).delegate = self
        requestNotificationPermission()
        // setup RX related
        setupRefreshTimer()
        setupNotification()
    }
    
    // MARK: Variables
    private var requestSentTime: Date?
    private var firstRequestSent = false
    
    // RX
    let loading: PublishSubject<Bool> = PublishSubject()
    let networkError : PublishSubject<NetworkError> = PublishSubject()
    let locationError : PublishSubject<LocationError> = PublishSubject()
    
    let townStatus : PublishSubject<StatusColors> = PublishSubject()
    let locationInfo : PublishSubject<LocationInfo> = PublishSubject()
    
    let notificationTapped : PublishSubject<Bool> = PublishSubject()
    
    private let disposeable = DisposeBag()
    
    // Setups
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

//MARK:- Location
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
        guard stateName == "Bavaria" else {
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

//MARK:- Network

extension LightsViewModel: CoronaNetworkable, CoronaNetworkableDelegate {
    func getIncidents(of townName: String,
                      previousRequestTime: Date?) {
        self.api.getIncidents(of: townName,
                              previousRequestTime: previousRequestTime)
    }
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
    
    func retryRequest() {
        if let townName = self.locationManager.locationInfo?.town {
            let longTimeAgo = Date(timeIntervalSince1970: 1)
            self.getIncidents(of: townName,
                              previousRequestTime: longTimeAgo)
        }
    }
}

//MARK:- Notification
extension LightsViewModel: Notificationable {
    func requestNotificationPermission() {
        notificationManager.requestNotificationPermission()
    }
    
    func sendLocalizedNotification(at timetInterval: TimeInterval) {
        notificationManager.sendLocalizedNotification(at: timetInterval)
    }
}

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
    
    // MARK: Dependencies
    private let network: Networkable
    private let locationManager: LocationManager
    private let notificationManager: Notificationable
    
    // Inject -> network + location manager + notification
    init(network: Networkable,
         locationManager: LocationManager,
         notificationManager: Notificationable) {
        // Injecting dependencies
        self.network = network
        self.locationManager = locationManager
        self.notificationManager = notificationManager
        locationManager.delegate = self
        requestNotificationPermission()
        // setup RX related
        setupRefreshTimer()
        setupNotification()
    }
    
    // MARK: Variables
    private var requestSentTime = Date()
    private var firstRequestSent = false
    
    // RX
    let loading: PublishSubject<Bool> = PublishSubject()
    let networkError : PublishSubject<NetworkError> = PublishSubject()
    let locationError : PublishSubject<LocationError> = PublishSubject()
    
    let townStatus : PublishSubject<LightColors> = PublishSubject()
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
                    self.getIncidents(of: townName)
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
}

//MARK:- Location
extension LightViewModel: LocationDelegate {
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
        getIncidents(of: townName)
    }
    
    func didNotAllowedLocationServices() {
        locationError.onNext(.locationNotAllowedError)
    }
}

//MARK:- Network
extension LightViewModel {
    private func timeDifferenceInSeconds(from: Date, until: Date) -> Int? {
        let diffComponents = Calendar.current.dateComponents([.second],
                                                             from: from,
                                                             to: until)
        return diffComponents.second
    }
    private func requestAllowed() -> Bool {
        // Check if request 30 seconds later send
        if !(firstRequestSent) { return true}
        
        let previousRequestTime = self.requestSentTime
        let now = Date()
        let differenceInSeconds = timeDifferenceInSeconds(from: previousRequestTime,
                                                          until: now)
        
        if let seconds = differenceInSeconds, seconds > 30 {
            return true
        }else {
            return false
        }
    }
    
    private func getIncidents(of townName: String) {
        
        guard requestAllowed() == true else { return}
        // Reset
        firstRequestSent = true
        requestSentTime = Date()
        
        
        // Call API
        loading.onNext(true)
        network.getStats(of: townName) {
            [unowned self]
            (incidents, networkError) in
            // Stop loading
            self.loading.onNext(false)
            
            // Handle Errors
            if let networkError = networkError {
                self.networkError.onNext(networkError)
                return
            }
            
            // Result
            if let incidents = incidents {
                setTownStatus(by: incidents)
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
}

//MARK:- Notification
extension LightViewModel: Notificationable {
    func requestNotificationPermission() {
        notificationManager.requestNotificationPermission()
    }
    
    func sendLocalizedNotification(at timetInterval: TimeInterval) {
        notificationManager.sendLocalizedNotification(at: timetInterval)
    }
}

enum LocationError {
    case locationNotAllowedError
    case outOfBavariaError
    case badLocationError
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationNotAllowedError:
            let message = NSLocalizedString("locationPermissionAlert",
                                            comment: "Location permission message")
            return message
        case .outOfBavariaError:
            let message = NSLocalizedString("locationOutOfBavariaError",
                                            comment: "Location permission message")
            return message
        case .badLocationError:
            let message = NSLocalizedString("locationDetectionError",
                                            comment: "Location permission message")
            return message
        }
    }
}

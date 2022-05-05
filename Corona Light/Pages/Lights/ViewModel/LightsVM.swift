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


class LightsVM {
    
    // MARK: Dependencies
    private var api: CoronaNetworkable
    private let locationManager: Locationable
    private let notificationManager: Notificationable
    private let mainCoordinatorDelegate: MainCoordinatorDelegate
    
    
    // Inject: coordinator delegate + network + location manager + notification
    init(mainCoordinatorDelegate: MainCoordinatorDelegate,
         coronaNetworking: CoronaNetworkable,
         locationManager: LocationManager,
         notificationManager: Notificationable) {
        // Injecting dependencies
        self.api = coronaNetworking
        self.locationManager = locationManager
        self.notificationManager = notificationManager
        self.mainCoordinatorDelegate = mainCoordinatorDelegate
        // Delegates conformation
        locationManager.delegate = self
        (coronaNetworking as? CoronaNetworking)?.delegate = self
        requestNotificationPermission()
        // setup RX related
        setupRefreshTimer()
        setupNotification()
    }
    
    
    // MARK: Variables
    private var requestSentTime: Date?
    private var allowedToCallAPI: Bool {
        // only if 30 sec passed from previous api call
        let timeDifference = requestSentTime?.seconds(from: Date()) ?? 31
        if  timeDifference > 30 {
            return true
        }
        return false
    }
    
    
    // MARK: RX Variables
    // UI
    let loading: PublishSubject<Bool> = PublishSubject()
    let networkError : PublishSubject<NetworkError> = PublishSubject()
    let locationError : PublishSubject<LocationError> = PublishSubject()
    let notificationTapped : PublishSubject<Bool> = PublishSubject()
    
    // Logic
    let townStatus : PublishSubject<StatusColors> = PublishSubject()
    let locationInfo : PublishSubject<LocationInfo> = PublishSubject()
    
    private let disposeable = DisposeBag()
    
    // For reset purpose
    private var localLocationInfo: LocationInfo?
    
    
    // MARK: RX Setups
    private func setupRefreshTimer() {
        let tenMinutes = RxTimeInterval.seconds(60 * 10)
        Observable<Int>
            .timer(RxTimeInterval.seconds(0),
                   period: tenMinutes,
                   scheduler: MainScheduler.instance)
            .subscribe { _ in
                if let townName = self.getLocationInfo()?.town {
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
                    self.sendLocalizedNotification()
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
    
    private func setTownStatus(by incidents: Int) {
        
        switch incidents {
        case ..<35:
            self.townStatus.onNext(.green)
        case 35...50:
            self.townStatus.onNext(.yellow)
        case 51...100:
            self.townStatus.onNext(.red)
        case 101..<Int.max:
            self.townStatus.onNext(.darkRed)
        default:
            self.townStatus.onNext(.off)
        }
    }
}


//MARK: Locationable
extension LightsVM: Locationable {
    
    func getLocationInfo() -> LocationInfo? {
        locationManager.getLocationInfo()
    }
    
    func startUpdatingLocation() {
        // It causes a signal to locationInfo that is
        // observing in LightVC = refresh descriptionLabel
        if let locationInfo = self.localLocationInfo {
            self.locationInfo.onNext(locationInfo)
        }
        // Invoke looking for location
        locationManager.startUpdatingLocation()
    }
}
// Location Delegate
extension LightsVM: LocationDelegate {
    func didUpdateLocation(to locationInfo: LocationInfo?) {
        print("Did update location at this town: \(String(describing: locationInfo?.town)).\n")
        
        // Wrap settled location
        guard let locationInfo = locationInfo,
              let stateName = locationInfo.state,
              let townName = locationInfo.town else {
            self.locationError.onNext(.badLocationError)
            return
        }
        
        // Check location
        guard let targetedStateName =
                Bundle.main.object(forInfoDictionaryKey: "stateName") as? String
                ,(stateName == targetedStateName)
        else {
            self.locationError.onNext(.outOfBavariaError)
            return
        }
        
        // Update UI
        self.localLocationInfo = locationInfo
        self.locationInfo.onNext(locationInfo)
        
        // Call API
        self.getIncidents(of: townName)
    }
    
    func didNotAllowedLocationServices() {
        locationError.onNext(.locationNotAllowedError)
    }
}


//MARK: Networkable
extension LightsVM: CoronaNetworkable {
    func getIncidents(of townName: String) {
        if allowedToCallAPI {
            self.api.getIncidents(of: townName)
        }
    }
    
    func retryRequest() {
        if let targetedStateName = Bundle.main.object(forInfoDictionaryKey: "stateName") as? String,
           let locationInfo = self.getLocationInfo(),
           let stateName = locationInfo.state,
           let townName = locationInfo.town,
           targetedStateName == stateName {
            self.getIncidents(of: townName)
        } else {
            self.locationError.onNext(.outOfBavariaError)
        }
    }
}

// Corona Networkable Delegate
extension LightsVM: CoronaNetworkableDelegate {
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


//MARK: Notificationable
extension LightsVM: Notificationable {
    func requestNotificationPermission() {
        notificationManager.requestNotificationPermission()
    }
    
    func sendLocalizedNotification() {
        notificationManager.sendLocalizedNotification()
    }
}


//MARK: Navigation
extension LightsVM: MainCoordinatorDelegate {
    func didSelect(statusColor: StatusColors) {
        mainCoordinatorDelegate.didSelect(statusColor: statusColor)
    }
}


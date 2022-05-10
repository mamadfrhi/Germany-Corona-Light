//
//  LightsVMAbstraction.swift
//  Corona Light
//
//  Created by iMamad on 5/2/22.
//

import RxSwift

// MARK: - MainCoordinator Delegate
protocol MainCoordinatorDelegate {
    func didSelect(statusColor: StatusColors)
}

// MARK: - VMType
protocol LightsVMType {
    
    // MARK: Delegates
    var mainCoordinatorDelegate: MainCoordinatorDelegate { get }
    
    // MARK: RX Variables
    var loading: PublishSubject<Bool> { get }
    var networkError : PublishSubject<NetworkError> { get }
    var locationError : PublishSubject<LocationError> { get }
    var notificationTapped : PublishSubject<Bool> { get }
    
    var townStatus : PublishSubject<StatusColors> { get }
    var locationInfo : PublishSubject<LocationInfo> { get }
}

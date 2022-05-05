//
//  MainCoordinator.swift
//  iOS-Challenge
//
//  Created by iMamad on 6/3/20.
//  Copyright © 2020 Mamad Farrahi. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // prepare dependencies
        let networking = CoronaNetworking(coronaAPI: CoronaAPI())
        let lightsVM = LightsVM(mainCoordinatorDelegate: self,
                                       coronaNetworking: networking,
                                       locationManager: LocationManager(),
                                       notificationManager: NotificationManager())
        let lightsVC = LightsVC(viewModel: lightsVM)
        // Show VC
        navigationController.pushViewController(lightsVC, animated: true)
    }
}

// MARK: - MainCoordinator Delegate
extension MainCoordinator: MainCoordinatorDelegate {
    func didSelect(statusColor: StatusColors) {
        goToRulesPage(by: statusColor)
    }
}

// MARK: - Navigation
extension MainCoordinator {
    func goToRulesPage(by statusColor: StatusColors) {
        let vc = RulesVC(statusColor: statusColor)
        navigationController.pushViewController(vc, animated: true)
    }
}

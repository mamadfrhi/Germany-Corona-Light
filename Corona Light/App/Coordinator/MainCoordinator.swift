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
        let lightsVM = LightsViewModel(coronaNetworking: networking,
                                        locationManager: LocationManager(),
                                        notificationManager: NotificationManager())
        let lightsVC = LightsVC(viewModel: lightsVM,
                                coordinator: self)
        // Show VC
        navigationController.pushViewController(lightsVC, animated: true)
    }
    
    func pushRulesPage(for statusColor: StatusColors) {
        goToRulesPage(with: statusColor)
    }
}

extension MainCoordinator {
    private func goToRulesPage(with statusColor: StatusColors) {
        let vc = RulesVC(statusColor: statusColor)
        navigationController.pushViewController(vc, animated: true)
    }
}

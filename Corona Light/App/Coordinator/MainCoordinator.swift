//
//  MainCoordinator.swift
//  iOS-Challenge
//
//  Created by iMamad on 6/3/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.barTintColor = .systemBlue
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController.navigationBar.tintColor = .white
    }
    
    func start() {
        let net = CoronaNetworking(coronaService: NetworkAdapter())
        let vm = LightsViewModel(network: net,
                                locationManager: LocationManager(),
                                notificationManager: NotificationManager())
        let lightVC = LightsVC(viewModel: vm,
                              coordinator: self)
        navigationController.pushViewController(lightVC, animated: true)
    }
    
    func pushRulesPage(for statusColor: StatusColors) {
        let vc = RulesVC(statusColor: statusColor)
        navigationController.pushViewController(vc, animated: true)
        print("I'm going to open RulesPage")
    }
}

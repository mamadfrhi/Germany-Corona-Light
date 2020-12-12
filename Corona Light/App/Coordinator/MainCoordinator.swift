//
//  MainCoordinator.swift
//  iOS-Challenge
//
//  Created by iMamad on 6/3/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit

class MainCoordinator : Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.barTintColor = .systemBlue
        navigationController
            .navigationBar
            .titleTextAttributes
            = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController.navigationBar.tintColor = .white
    }
    
    // MARK:-
    // MARK: Coordinate functions
    // MARK:-
    func start() {
        
        // Fire up networking
        // It made from CoronaAPI = Adapter of moya
        let networking = CoronaNetworking(coronaAPI: CoronaAPI())
        // Fire up ViewModel
        let viewModel = LightsViewModel(coronaNetworking: networking,
                                        locationManager: LocationManager(),
                                        notificationManager: NotificationManager())
        let lightsVC = LightsVC(viewModel: viewModel,
                               coordinator: self)
        // Show VC
        navigationController.pushViewController(lightsVC, animated: true)
    }
    
    func pushRulesPage(for statusColor: StatusColors) {
        let vc = RulesVC(statusColor: statusColor)
        navigationController.pushViewController(vc, animated: true)
    }
}

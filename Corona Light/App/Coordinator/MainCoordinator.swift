//
//  MainCoordinator.swift
//  iOS-Challenge
//
//  Created by iMamad on 6/3/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit

let numberOfLights = 4

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
//        goToRulesPage()
//        return
        let vm = LightViewModel(network: NetworkManager(),
                                locationManager: LocationManager(),
                                notificationManager: NotificationManager())
        
        
        // Making view
        //TODO: Clean it
        let lightManager = LightManager()
        
        let view = TrafficLightView(frame: UIScreen.main.bounds,
                                    lightManager: lightManager)
        let lightVC = LightVC(viewModel: vm,
                              trafficLightView: view,
                              coordinator: self)
        navigationController.pushViewController(lightVC, animated: true)
    }
    
    func showRules(for statusColor: LightColors) {
        let vc = RulesVC(statusColor: statusColor)
        navigationController.pushViewController(vc, animated: true)
        print("I'm going to open RulesPage")
    }
}

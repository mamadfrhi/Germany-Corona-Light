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
        let vm = LightViewModel(network: NetworkManager(),
                                locationManager: LocationManager())
        
        
        // Making view
        //TODO: Clean it
        let lightHeight = CGFloat(((UIScreen.main.bounds.height * 0.6) / CGFloat(numberOfLights)) - 10)
        let lightManager = LightManager(lightHeight: lightHeight)
        
        let view = TrafficLightView(frame: UIScreen.main.bounds,
                                    lightManager: lightManager)
        let lightVC = LightVC(viewModel: vm,
                              trafficLightView: view,
                              coordinator: self)
        navigationController.pushViewController(lightVC, animated: true)
    }
    
    func goToRulesPage() {
        print("I'm going to open RulesPage")
    }
}

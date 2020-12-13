//
//  AppDelegate.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup Coordinator
        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()
        
        // create a basic UIWindow and activate it
        window = UIWindow(frame: screenBounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
}


//
//  AppCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init() {
        navigator = UINavigationController()
    }
    
    func start() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isSecondLaunchBoolKey.rawValue) {
            let weatherMainCoordinator = WeatherMainCoordinator(controller: navigator, parent: self)
            weatherMainCoordinator.start()
            childCoordinators.append(weatherMainCoordinator)
        } else {
            let onboardingCoordinator = OnboardingCoordinator(controller: navigator, parent: self)
            onboardingCoordinator.start()
            childCoordinators.append(onboardingCoordinator)
        }
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

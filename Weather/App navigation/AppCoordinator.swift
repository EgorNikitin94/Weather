//
//  AppCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    //MARK: - Properties
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    //MARK: - Init

    init() {
        navigator = UINavigationController()
    }

    //MARK: - Methods

    func start() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isSecondLaunchBoolKey.rawValue) {
            let weatherMainCoordinator = WeatherMainCoordinator(controller: navigator, parent: self)
            weatherMainCoordinator.start()
            childCoordinators.append(weatherMainCoordinator)
        } else {
            let onboardingCoordinator = GeolocationCoordinator(controller: navigator, viewControllerState: .onboarding, parent: self)
            onboardingCoordinator.start()
            childCoordinators.append(onboardingCoordinator)
        }
    }
    
    func childDidFinish(_ child: Coordinator?) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }

}

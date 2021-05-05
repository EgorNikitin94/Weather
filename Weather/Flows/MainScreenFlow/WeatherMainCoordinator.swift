//
//  WeatherMainCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

class WeatherMainCoordinator: Coordinator {
    
    unowned var parentCoordinator: Coordinator
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    func start() {
        let weatherMainViewController = WeatherMainViewController()
        weatherMainViewController.coordinator = self
        //navigator.show(weatherMainViewController, sender: self)
        navigator.pushViewController(weatherMainViewController, animated: true)
    }
    
    func didFinishWeather() {
        parentCoordinator.childDidFinish(self)
    }
    
    func pushSettingsViewController() {
        let settingsCoordinator = SettingsCoordinator(controller: navigator, parent: self)
        settingsCoordinator.navigator = navigator
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
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

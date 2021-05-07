//
//  SettingsCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

class SettingsCoordinator: Coordinator {
    
    unowned var parentCoordinator: Coordinator
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    func start() {
        let settingsViewController = SettingsViewController()
        settingsViewController.coordinator = self
        navigator.pushViewController(settingsViewController, animated: true)
    }
    
    func didFinishWeather() {
        parentCoordinator.childDidFinish(self)
    }
    
    func popToWeatherMainViewController() {
        navigator.popViewController(animated: false)
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

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
    
    func didFinishSettings() {
        parentCoordinator.childDidFinish(self)
    }
    
    
    func pushWeatherMainViewController() {
        let weatherMainCoordinator = WeatherMainCoordinator(controller: navigator, parent: self)
        childCoordinators.append(weatherMainCoordinator)
        weatherMainCoordinator.start()
    }
    
    func popToWeatherMainViewController() {
        navigator.popViewController(animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}

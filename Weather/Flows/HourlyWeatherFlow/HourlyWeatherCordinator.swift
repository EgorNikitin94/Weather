//
//  HourlyWeatherCordinator.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

final class HourlyWeatherCoordinator: Coordinator {
    
    unowned var parentCoordinator: Coordinator
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    func start() {
        let hourlyWeatherViewModel = HourlyWeatherViewModel()
        let hourlyWeatherViewController = HourlyWeatherViewController(viewModel: hourlyWeatherViewModel)
        hourlyWeatherViewController.coordinator = self
        navigator.pushViewController(hourlyWeatherViewController, animated: true)
    }
    
    func didFinishHourlyWeather() {
        parentCoordinator.childDidFinish(self)
    }
    
    func popToWeatherMainViewController() {
        navigator.popViewController(animated: true)
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

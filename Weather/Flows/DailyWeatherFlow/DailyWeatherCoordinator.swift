//
//  DailyWeatherCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

final class DailyWeatherCoordinator: Coordinator {
    
    unowned var parentCoordinator: Coordinator
    
    var cachedWeather: CachedWeather?
    
    var selectedIndex: Int = 1
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    func start() {
        let dailyWeatherViewModel = DailyWeatherViewModel(cachedWeather: cachedWeather)
        let dailyWeatherViewController = DailyWeatherViewController(viewModel: dailyWeatherViewModel)
        dailyWeatherViewController.coordinator = self
        dailyWeatherViewController.selectedIndex = selectedIndex
        navigator.pushViewController(dailyWeatherViewController, animated: true)
    }
    
    func didFinishDailyWeather() {
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

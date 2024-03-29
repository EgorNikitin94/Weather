//
//  HourlyWeatherCordinator.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

final class HourlyWeatherCoordinator: Coordinator {
    
    //MARK: - Properties
    
    unowned var parentCoordinator: Coordinator
    
    var cachedWeather: CachedWeather?
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    //MARK: - Init
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    //MARK: -  Methods
    
    func start() {
        let hourlyWeatherViewModel = HourlyWeatherViewModel(cachedWeather: cachedWeather)
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
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}

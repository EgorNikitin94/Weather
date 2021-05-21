//
//  WeatherMainCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

final class WeatherMainCoordinator: Coordinator {
    
    unowned var parentCoordinator: Coordinator
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    func start() {
        let pageViewController = FlowFactory.makeMainScreenFlow(coordinator: self)
        navigator.pushViewController(pageViewController, animated: true)
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
    
    func pushHourlyWeatherViewController() {
        let hourlyWeatherCoordinator = HourlyWeatherCoordinator(controller: navigator, parent: self)
        hourlyWeatherCoordinator.navigator = navigator
        childCoordinators.append(hourlyWeatherCoordinator)
        hourlyWeatherCoordinator.start()
    }
    
    func pushDailyWeatherViewController(weatherData: WeatherData?, selectedIndex: Int) {
        let dailyWeatherCoordinator = DailyWeatherCoordinator(controller: navigator, parent: self)
        dailyWeatherCoordinator.weatherData = weatherData
        dailyWeatherCoordinator.navigator = navigator
        dailyWeatherCoordinator.selectedIndex = selectedIndex
        childCoordinators.append(dailyWeatherCoordinator)
        dailyWeatherCoordinator.start()
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

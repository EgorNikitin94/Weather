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
    
    func pushGeolocationViewController() {
        let geolocationCoordinator = GeolocationCoordinator(controller: navigator, parent: self)
        geolocationCoordinator.navigator = navigator
        childCoordinators.append(geolocationCoordinator)
        geolocationCoordinator.start()
    }
    
    func pushHourlyWeatherViewController(cachedWeather: CachedWeather?) {
        let hourlyWeatherCoordinator = HourlyWeatherCoordinator(controller: navigator, parent: self)
        hourlyWeatherCoordinator.navigator = navigator
        hourlyWeatherCoordinator.cachedWeather = cachedWeather
        childCoordinators.append(hourlyWeatherCoordinator)
        hourlyWeatherCoordinator.start()
    }
    
    func pushDailyWeatherViewController(cachedWeather: CachedWeather?, selectedIndex: Int) {
        let dailyWeatherCoordinator = DailyWeatherCoordinator(controller: navigator, parent: self)
        dailyWeatherCoordinator.cachedWeather = cachedWeather
        dailyWeatherCoordinator.navigator = navigator
        dailyWeatherCoordinator.selectedIndex = selectedIndex
        childCoordinators.append(dailyWeatherCoordinator)
        dailyWeatherCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}

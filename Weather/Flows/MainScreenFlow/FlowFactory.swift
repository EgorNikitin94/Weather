//
//  MainScreenFlowFactory.swift
//  Weather
//
//  Created by Егор Никитин on 16.05.2021.
//

import UIKit

struct FlowFactory {
    
    static func makeMainScreenFlow(coordinator: WeatherMainCoordinator) -> UIPageViewController {
        
        let pageViewController = WeatherPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isTrackingBoolKey.rawValue) {
            let weatherMainViewController = makeWeatherMainViewController(coordinator: coordinator, stateViewController: .currentLocationWeather, pageViewController: pageViewController)
            //pageViewController.orderedViewControllers.append(weatherMainViewController)
            pageViewController.appendNewViewController(newViewController: weatherMainViewController)
        }
        
        let weather = RealmDataManager.sharedInstance.getCachedWeather()
        if !weather.isEmpty {
            for cityWeather in weather {
                let weatherMainViewController = makeWeatherMainViewController(coordinator: coordinator, stateViewController: .selectedCityWeather, pageViewController: pageViewController, cityWeather:  cityWeather)
                //pageViewController.orderedViewControllers.append(weatherMainViewController)
                pageViewController.appendNewViewController(newViewController: weatherMainViewController)
            }
        }
        
        let weatherMainViewController = makeWeatherMainViewController(coordinator: coordinator, stateViewController: .emptyWithPlus, pageViewController: pageViewController)
 
        //pageViewController.orderedViewControllers.append(weatherMainViewController)
        pageViewController.appendNewViewController(newViewController: weatherMainViewController)
        
        return pageViewController
    }
    
    static func makeWeatherMainViewController(coordinator: WeatherMainCoordinator?, stateViewController: MainWeatherControllerState, pageViewController: WeatherPageViewController?, cityWeather: CachedWeather) -> WeatherMainViewController {
        let viewModel = WeatherMainViewModel()
        let weatherMainViewController = WeatherMainViewController(viewModel: viewModel, stateViewController: stateViewController)
        weatherMainViewController.coordinator = coordinator
        weatherMainViewController.weatherPageViewController = pageViewController
        viewModel.cachedWeather = cityWeather
        return weatherMainViewController
    }
    
    static func makeWeatherMainViewController(coordinator: WeatherMainCoordinator?, stateViewController: MainWeatherControllerState, pageViewController: WeatherPageViewController?) -> WeatherMainViewController {
        let viewModel = WeatherMainViewModel()
        let weatherMainViewController = WeatherMainViewController(viewModel: viewModel, stateViewController: stateViewController)
        weatherMainViewController.coordinator = coordinator
        weatherMainViewController.weatherPageViewController = pageViewController
        return weatherMainViewController
    }
    
}

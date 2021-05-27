//
//  WeatherPageViewController.swift
//  Weather
//
//  Created by Егор Никитин on 13.05.2021.
//

import UIKit


final class WeatherPageViewController: UIPageViewController {
    //MARK: - Properties

    var orderedViewControllers: [WeatherMainViewController] = []

    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        dataSource = self
        
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(viewController: initialViewController)
        }
        
    }
    
    //MARK: - Methods
    
    func insertLocationWeatherMainViewController(weatherMainViewController: WeatherMainViewController) {
        orderedViewControllers.insert(weatherMainViewController, at: 0)
        
        for (index, weatherMainViewController) in orderedViewControllers.enumerated() {
            weatherMainViewController.numberOfPages = orderedViewControllers.count
            weatherMainViewController.currentPage = index
        }
    }
    
    func deleteLocationWeatherMainViewController() {
        if !orderedViewControllers.isEmpty {
            orderedViewControllers.removeFirst()
        }
        
        for (index, weatherMainViewController) in orderedViewControllers.enumerated() {
            weatherMainViewController.numberOfPages = orderedViewControllers.count
            weatherMainViewController.currentPage = index
        }
        
        RealmDataManager.sharedInstance.deleteCurrentLocationCachedWeather()
    }
    
    func appendNewViewController(newViewController: WeatherMainViewController) {
        orderedViewControllers.append(newViewController)
        
        for (index, weatherMainViewController) in orderedViewControllers.enumerated() {
            weatherMainViewController.numberOfPages = orderedViewControllers.count
            weatherMainViewController.currentPage = index
        }
    }
    
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first, let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            scrollToViewController(viewController: nextViewController)
        }
    }
    
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first as? WeatherMainViewController,
           let currentIndex = orderedViewControllers.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }

    
    private func scrollToViewController(viewController: UIViewController, direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController], direction: direction, animated: true, completion: { (finished) -> Void in
           
        })
    }
}

// MARK: UIPageViewControllerDataSource
extension WeatherPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherMainViewController, let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherMainViewController, let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

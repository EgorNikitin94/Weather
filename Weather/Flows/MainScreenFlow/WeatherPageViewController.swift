//
//  WeatherPageViewController.swift
//  Weather
//
//  Created by Егор Никитин on 13.05.2021.
//

import UIKit

protocol WeatherPageViewControllerDelegate: class {
    
    func weatherPageViewController(weatherPageViewController: WeatherPageViewController, didUpdatePageCount count: Int)
    
    func weatherPageViewController(weatherPageViewController: WeatherPageViewController, didUpdatePageIndex index: Int)
    
}


final class WeatherPageViewController: UIPageViewController {
    
    weak var weatherDelegate: WeatherPageViewControllerDelegate?
    
    var orderedViewControllers: [WeatherMainViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(viewController: initialViewController)
        }
        
        weatherDelegate?.weatherPageViewController(weatherPageViewController: self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    
    func appendNewViewController(newViewController: WeatherMainViewController) {
        
        orderedViewControllers.append(newViewController)
        
        for weatherMainViewController in orderedViewControllers {
            weatherMainViewController.numberOfPages = orderedViewControllers.count
        }
    }
    
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first, let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            scrollToViewController(viewController: nextViewController)
        }
    }
    
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
           let currentIndex = orderedViewControllers.firstIndex(of: firstViewController as! WeatherMainViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }

    
    private func scrollToViewController(viewController: UIViewController, direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController], direction: direction, animated: true, completion: { (finished) -> Void in
           
            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    

    private func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
           let index = orderedViewControllers.firstIndex(of: firstViewController as! WeatherMainViewController) {
            weatherDelegate?.weatherPageViewController(weatherPageViewController: self, didUpdatePageIndex: index)
        }
    }
    
}

// MARK: UIPageViewControllerDataSource
extension WeatherPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! WeatherMainViewController) else {
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
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! WeatherMainViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil            }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

extension WeatherPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }
    
}

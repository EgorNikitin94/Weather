//
//  OnboardingCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    
    unowned var parentCoordinator: Coordinator
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    func start() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.coordinator = self
        navigator.show(onboardingViewController, sender: self)
    }
    
    func pushWeatherMainViewController() {
        let weatherMainCoordinator = WeatherMainCoordinator(controller: navigator, parent: self)
        childCoordinators.append(weatherMainCoordinator)
        weatherMainCoordinator.start()
    }
    
    func showAlert() {
        let alertViewController = UIAlertController(title: "Внимание!", message: "Вы не дали разрешение на отслеживание геолокации. Если вы хотите определить автоматически ваше местоположение, перейдите в настройки.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            //
        }
        alertViewController.addAction(okAction)
        navigator.present(alertViewController, animated: true)
    }
    
    func didFinishOnboarding() {
        //parentCoordinator.childDidFinish(self)
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

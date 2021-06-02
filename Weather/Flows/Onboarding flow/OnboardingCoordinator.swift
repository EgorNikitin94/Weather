//
//  OnboardingCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

class GeolocationCoordinator: Coordinator {
    
    unowned var parentCoordinator: Coordinator
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    func start() {
        let onboardingViewController = GeolocationViewController()
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
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (action) in
            //UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            guard let url = URL(string: "App-Prefs:root=General") else {
                return
            }
            UIApplication.shared.open(url)
        }
        let cancelAction = UIAlertAction(title: "отмена", style: .cancel) { (action) in
            // Close alert
        }
        alertViewController.addAction(settingsAction)
        alertViewController.addAction(cancelAction)
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

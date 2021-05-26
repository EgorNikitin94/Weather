//
//  OnboardingCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

final class GeolocationCoordinator: Coordinator {
    
    unowned var parentCoordinator: Coordinator
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(controller: UINavigationController, parent: Coordinator) {
        self.navigator = controller
        self.parentCoordinator = parent
    }
    
    func start() {
        let geolocationViewController = GeolocationViewController()
        geolocationViewController.coordinator = self
        navigator.pushViewController(geolocationViewController, animated: true)
    }
    
    func pushSettingsViewController() {
        let settingsCoordinator = SettingsCoordinator(controller: navigator, parent: self)
        settingsCoordinator.navigator = navigator
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
    }
    
    func popToWeatherMainViewController() {
        navigator.popViewController(animated: true)
    }
    
    func showAlert() {
        let alertViewController = UIAlertController(title: "Внимание!", message: "Вы не дали разрешение на отслеживание геолокации. Если вы хотите определить автоматически ваше местоположение, перейдите в настройки.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (action) in
            //App-Prefs:root=General
            guard let url = URL(string: "Prefs:root=Privacy&path=LOCATION") else {
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
    
    func didFinishGeolocation() {
        parentCoordinator.childDidFinish(self)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}

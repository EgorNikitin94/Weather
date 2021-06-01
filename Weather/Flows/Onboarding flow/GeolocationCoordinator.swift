//
//  OnboardingCoordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

final class GeolocationCoordinator: Coordinator {
    
    //MARK: - Properties
    
    weak var parentCoordinator: Coordinator?
    
    private let viewControllerState: GeolocationViewControllerState
    
    var navigator: UINavigationController
    var childCoordinators = [Coordinator]()
    
    //MARK: - Init

    init(controller: UINavigationController, viewControllerState: GeolocationViewControllerState, parent: Coordinator) {
        self.navigator = controller
        self.viewControllerState = viewControllerState
        self.parentCoordinator = parent
    }
    
    //MARK: - Methods
    
    func start() {
        let geolocationViewController = GeolocationViewController(stateViewController: viewControllerState)
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
        let settingsAction = UIAlertAction(title: "перейти", style: .default) { (action) in
            guard let url = URL(string: "\(UIApplication.openSettingsURLString)") else {
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
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}

//
//  WeatherMainViewController.swift
//  Weather
//
//  Created by Егор Никитин on 04.05.2021.
//

import UIKit

final class WeatherMainViewController: UIViewController {
    
    var coordinator: WeatherMainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    @objc private func openSettings() {
        print("SettingsButton")
    }
    
    @objc private func addCity() {
        print("CityButton")
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
        let settingsButtonImage = UIImage(named: "Settings")
        let cityButtonImage = UIImage(named: "Mark")
        let resizedCityButtonImage = cityButtonImage?.resized(to: CGSize(width: 20, height: 26))
        
        let settingsButton = UIBarButtonItem(image: settingsButtonImage, style: .plain, target: self, action: #selector(openSettings))
        let cityButton = UIBarButtonItem(image: resizedCityButtonImage, style: .plain, target: self, action: #selector(addCity))
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = cityButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    
}

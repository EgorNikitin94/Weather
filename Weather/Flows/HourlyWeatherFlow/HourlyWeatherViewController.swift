//
//  HourlyWeatherViewController.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

final class HourlyWeatherViewController: UIViewController {
    
    var coordinator: HourlyWeatherCoordinator?
    
    private var viewModelOutput: HourlyWeatherViewModelOutput
    
    // Mark: - init
    
    init(viewModel: HourlyWeatherViewModelOutput) {
        self.viewModelOutput = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        coordinator?.didFinishHourlyWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        
        title = "Hourly"
        
        navigationController?.navigationBar.isHidden = false
 
    }
    
}

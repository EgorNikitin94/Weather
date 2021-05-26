//
//  SettingsViewController.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    var coordinator: SettingsCoordinator?
    
    private lazy var settingsView: SettingsView = {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        return $0
    }(SettingsView())
    
    private lazy var topCloudImageView: UIImageView = {
        $0.image = UIImage(named: "TopCloud")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var middleCloudImageView: UIImageView = {
        $0.image = UIImage(named: "MiddleCloud")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var bottomCloudImageView: UIImageView = {
        $0.image = UIImage(named: "BottomCloud")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        view.backgroundColor = AppColors.sharedInstance.accentBlue
        setupLayout()
        onSetupButtonTapped()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.didFinishSettings()
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
    }
    
    
    private func onSetupButtonTapped() {
        if let settingsCoordinator = coordinator {
            settingsView.onSetupButtonTapped = {
                if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isSecondLaunchBoolKey.rawValue) {
                    settingsCoordinator.popToWeatherMainViewController()
                } else {
                    settingsCoordinator.pushWeatherMainViewController()
                }
                
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(settingsView)
        view.addSubview(topCloudImageView)
        view.addSubview(middleCloudImageView)
        view.addSubview(bottomCloudImageView)
        
        topCloudImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(37)
            make.leading.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
        
        middleCloudImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topCloudImageView.snp.bottom).offset(25.9)
            make.trailing.equalToSuperview()
            make.width.equalTo(182.3)
            make.height.equalTo(94.2)
            
        }
        
        settingsView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(330)
        }
        
        bottomCloudImageView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-94.9)
            make.centerX.equalToSuperview()
            make.width.equalTo(216.8)
            make.height.equalTo(65.1)
            
        }
    }
    
}

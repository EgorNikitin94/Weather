//
//  WeatherMainViewController.swift
//  Weather
//
//  Created by Егор Никитин on 04.05.2021.
//

import UIKit

final class WeatherMainViewController: UIViewController {
    
    var coordinator: WeatherMainCoordinator?
    
    private lazy var navigationTitle: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "Moscow,Russia", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var bottomSafeArea: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.accentBlue
        return $0
    }(UIView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
    }
    
    @objc private func openSettings() {
        coordinator?.pushSettingsViewController()
    }
    
    @objc private func addCity() {
        print("CityButton")
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true

        navigationItem.titleView = navigationTitle
        
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
    
    private func setupLayout() {
        view.addSubview(bottomSafeArea)
        
        bottomSafeArea.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    
}

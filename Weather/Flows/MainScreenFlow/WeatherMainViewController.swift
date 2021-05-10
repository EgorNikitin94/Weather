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
    
    private lazy var mainWeatherInformationView: MainWeatherInformationView = {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        return $0
    }(MainWeatherInformationView())
    
    private lazy var detailsLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "Подробнее на 24 часа", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsLabelTapped))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGestureRecognizer)
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
    
    @objc private func detailsLabelTapped() {
        print("did Tap")
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
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
        
        //        let navBarsize = navigationController!.navigationBar.bounds.size
        //        let origin = CGPoint(x: navBarsize.width/2, y: navBarsize.height/2)
        //
        //        let pageControl = UIPageControl(frame: CGRect(x: origin.x - 50, y: 45, width: 100, height: 10))
        //        pageControl.numberOfPages = 2
        //        pageControl.currentPage = 1
        //
        //        navigationController?.navigationBar.addSubview(pageControl)
    }
    
    private func setupLayout() {
        view.addSubview(bottomSafeArea)
        view.addSubview(mainWeatherInformationView)
        view.addSubview(detailsLabel)
        
        mainWeatherInformationView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(112)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(215)
        }
        
        detailsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainWeatherInformationView.snp.bottom).offset(33)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        bottomSafeArea.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    
}

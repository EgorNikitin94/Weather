//
//  WeatherMainViewController.swift
//  Weather
//
//  Created by Егор Никитин on 04.05.2021.
//

import UIKit

protocol WeatherMainViewControllerOutput {
    var onDataLoaded: (()->Void)? { get set }
    func configureMainInformationView() -> (dailyTemperature: String, currentTemperature: String, descriptionWeather: String, cloudy: String, windSpeed: String, humidity: String, sunrise: String, sunset: String, currentDate: String)?
    func configureHourlyItem(with object: Hourly) -> (time: String, image: UIImage?, temperature: String)?
    func configureDailyItem(with object: Daily) -> (dayDate: String, image: UIImage?, humidity: String, descriptionWeather: String, temperature: String)?
    func getHourlyWeatherArray() -> [Hourly]
    func getDailyWeatherArray() -> [Daily]
}

final class WeatherMainViewController: UIViewController {
    
    var coordinator: WeatherMainCoordinator?
    
    private var viewModel: WeatherMainViewControllerOutput
    
    private lazy var navigationTitle: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "Los Angeles,USA", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
    
    private lazy var hourlyForecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collection.register(HourlyForecastCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HourlyForecastCollectionViewCell.self))
        collection.dataSource = self
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private lazy var dailyForecastLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.attributedText = NSMutableAttributedString(string: "Ежедневный прогноз", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var daysCountLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "25 дней", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(daysCountLabelTapped))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UILabel())
    
    private lazy var dailyForecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.register(DailyForecastCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DailyForecastCollectionViewCell.self))
        collection.dataSource = self
        collection.delegate = self
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    private lazy var bottomSafeArea: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.accentBlue
        return $0
    }(UIView())
    
    // Mark: - init
    
    init(viewModel: WeatherMainViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
        getData()
    }
    
    private func getData() {
        viewModel.onDataLoaded = {
            self.mainWeatherInformationView.viewConfigure = self.viewModel.configureMainInformationView()
            self.hourlyForecastCollectionView.reloadData()
            self.dailyForecastCollectionView.reloadData()
        }
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
    
    @objc private func daysCountLabelTapped() {
        print("daysCountLabel Tap")
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
        view.addSubview(mainWeatherInformationView)
        view.addSubview(detailsLabel)
        view.addSubview(hourlyForecastCollectionView)
        view.addSubview(dailyForecastLabel)
        view.addSubview(daysCountLabel)
        view.addSubview(dailyForecastCollectionView)
        view.addSubview(bottomSafeArea)
        
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
        
        hourlyForecastCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(detailsLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(83)
        }
        
        dailyForecastLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hourlyForecastCollectionView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
        }
        
        daysCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hourlyForecastCollectionView.snp.bottom).offset(43)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        dailyForecastCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(dailyForecastLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(bottomSafeArea.snp.top)
        }
        
        bottomSafeArea.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    
}




extension WeatherMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyForecastCollectionView {
            return viewModel.getHourlyWeatherArray().count
        }
        return viewModel.getDailyWeatherArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyForecastCollectionView {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyForecastCollectionViewCell.self), for: indexPath) as! HourlyForecastCollectionViewCell
            let hurlyWeatherArray = viewModel.getHourlyWeatherArray()
            let hourlyWeather = hurlyWeatherArray[indexPath.item]
            item.configure = viewModel.configureHourlyItem(with: hourlyWeather)
            return item
        }
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DailyForecastCollectionViewCell.self), for: indexPath) as! DailyForecastCollectionViewCell
        let dailyWeatherArray = viewModel.getDailyWeatherArray()
        let dailyWeather = dailyWeatherArray[indexPath.item]
        item.configure = viewModel.configureDailyItem(with: dailyWeather)
        return item
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == hourlyForecastCollectionView {
            return CGSize(width: 42, height: 83)
        }
        return CGSize(width: collectionView.frame.width - 16 - 15, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == hourlyForecastCollectionView else { return }
        let cell = collectionView.cellForItem(at: indexPath) as! HourlyForecastCollectionViewCell
        if cell.isSelected {
            cell.configureSelectedItem()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == hourlyForecastCollectionView, let cell = collectionView.cellForItem(at: indexPath) as? HourlyForecastCollectionViewCell {
            if !cell.isSelected {
                cell.configureUnselectedItem()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == hourlyForecastCollectionView {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        return UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 15)
    }
}

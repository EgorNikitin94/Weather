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
    func configureCityName() -> String?
}

enum MainWeatherControllerState {
    case currentLocationWeather
    case emptyWithPlus
    case selectedCityWeather
}

final class WeatherMainViewController: UIViewController {
    
    var coordinator: WeatherMainCoordinator?
    
    private var stateViewController: MainWeatherControllerState
    
    private var viewModel: WeatherMainViewControllerOutput
    
    var weatherPageViewController: WeatherPageViewController? {
        didSet {
            weatherPageViewController?.weatherDelegate = self
        }
    }
    
    private lazy var cityNameLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        $0.textAlignment = .right
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.attributedText = NSMutableAttributedString(string: "Unknown", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var settingsButton: UIButton = {
        $0.setImage(UIImage(named: "Settings"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var geolocationButton: UIButton = {
        $0.setImage(UIImage(named: "Mark"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(useGeolocation), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    private lazy var pageControl: UIPageControl = {
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .blue
        $0.addTarget(self, action: #selector(didChangePageControlValue), for: .valueChanged)
        return $0
    }(UIPageControl())
    
    private lazy var plusImage: UIImageView = {
        $0.image = UIImage(named: "Plus")
        $0.contentMode = .scaleToFill
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusImageTapped))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGestureRecognizer)
        $0.isHidden = stateViewController == .emptyWithPlus ? false : true
        return $0
    }(UIImageView())
    
    private lazy var mainWeatherInformationView: MainWeatherInformationView = {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.isHidden = stateViewController == .emptyWithPlus ? true : false
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
        $0.isHidden = stateViewController == .emptyWithPlus ? true : false
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
        collection.isHidden = stateViewController == .emptyWithPlus ? true : false
        return collection
    }()
    
    private lazy var dailyForecastLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.attributedText = NSMutableAttributedString(string: "Ежедневный прогноз", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        $0.isHidden = stateViewController == .emptyWithPlus ? true : false
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
        $0.isHidden = stateViewController == .emptyWithPlus ? true : false
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
        collection.isHidden = stateViewController == .emptyWithPlus ? true : false
        return collection
    }()
    
    private lazy var bottomSafeArea: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.accentBlue
        return $0
    }(UIView())
    
    // Mark: - init
    
    init(viewModel: WeatherMainViewModel, stateViewController: MainWeatherControllerState) {
        self.viewModel = viewModel
        self.stateViewController = stateViewController
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        pageControl.numberOfPages = weatherPageViewController?.orderedViewControllers.count ?? 1
        pageControl.currentPage = 0
//        if #available(iOS 14.0, *) {
//            guard let viewControllersArray = weatherPageViewController?.orderedViewControllers else {return}
//            for (index, _) in viewControllersArray.enumerated() {
//                if pageControl.currentPage == index {
//                    let image = UIImage(systemName: "circlebadge.fill")!.withTintColor(.black)
//                    pageControl.setIndicatorImage(image, forPage: index)
//                } else {
//                    let image = UIImage(systemName: "circlebadge")!.withTintColor(.black)
//                    pageControl.setIndicatorImage(image, forPage: index)
//                }
//            }
//        } else {
//            pageControl.customPageControl(dotFillColor: .black, dotBorderColor: .black, dotBorderWidth: 1)
//        }
        setupNavigationBar()
        setupLayout()
        getData()
    }
    
    private func getData() {
        viewModel.onDataLoaded = {
            self.updateData()
        }
    }
    
    private func updateData() {
        mainWeatherInformationView.viewConfigure = viewModel.configureMainInformationView()
        hourlyForecastCollectionView.reloadData()
        dailyForecastCollectionView.reloadData()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        guard let cityName = viewModel.configureCityName() else {
            return
        }
        cityNameLabel.attributedText = NSMutableAttributedString(string: cityName, attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    @objc func plusImageTapped() {
        let alertController = UIAlertController(title: "Введите название города для отображения погоды", message: nil, preferredStyle: .alert)
        alertController.addTextField { (text) in
            text.placeholder = "название города"
        }
        let alertActionFind = UIAlertAction(title: "ОК", style: .default) {  (alert) in//[weak self]
            //guard let self = self else { return }
            let cityName = alertController.textFields?[0].text
            if let name = cityName, name != "" {
                NetworkService.getGeolocationOfCity(cityName: name) { (city) in
                    print(city)
                }
            }
            
        }
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(alertActionFind)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func didChangePageControlValue() {
        weatherPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    @objc private func openSettings() {
        coordinator?.pushSettingsViewController()
    }
    
    @objc private func useGeolocation() {
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
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationController?.navigationBar.shadowImage = UIImage()
        //        navigationController?.navigationBar.isTranslucent = true
        //
        //        navigationItem.titleView = navigationTitle
        //
        //        let settingsButtonImage = UIImage(named: "Settings")
        //        let cityButtonImage = UIImage(named: "Mark")
        //        let resizedCityButtonImage = cityButtonImage?.resized(to: CGSize(width: 20, height: 26))
        //
        //        let settingsButton = UIBarButtonItem(image: settingsButtonImage, style: .plain, target: self, action: #selector(openSettings))
        //        let cityButton = UIBarButtonItem(image: resizedCityButtonImage, style: .plain, target: self, action: #selector(addCity))
        //        navigationItem.leftBarButtonItem = settingsButton
        //        navigationItem.rightBarButtonItem = cityButton
        //        navigationItem.leftBarButtonItem?.tintColor = .black
        //        navigationItem.rightBarButtonItem?.tintColor = .black
        //
    }
    
    private func setupLayout() {
        view.addSubview(cityNameLabel)
        view.addSubview(settingsButton)
        view.addSubview(geolocationButton)
        view.addSubview(pageControl)
        view.addSubview(plusImage)
        view.addSubview(mainWeatherInformationView)
        view.addSubview(detailsLabel)
        view.addSubview(hourlyForecastCollectionView)
        view.addSubview(dailyForecastLabel)
        view.addSubview(daysCountLabel)
        view.addSubview(dailyForecastCollectionView)
        view.addSubview(bottomSafeArea)
        
        cityNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        settingsButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(cityNameLabel)
            make.width.equalTo(36)
            make.height.equalTo(20)
        }
        
        geolocationButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(cityNameLabel)
            make.width.equalTo(20)
            make.height.equalTo(26)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityNameLabel.snp.bottom).offset(19)
        }
        
        plusImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        mainWeatherInformationView.snp.makeConstraints { (make) in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
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
            if indexPath.item == 1 {
                item.prepareForReuse()
                item.configureSelectedItem()
            }
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
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == hourlyForecastCollectionView {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        return UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 15)
    }
}

extension WeatherMainViewController: WeatherPageViewControllerDelegate {
    
    func weatherPageViewController(weatherPageViewController: WeatherPageViewController,
                                   didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func weatherPageViewController(weatherPageViewController: WeatherPageViewController,
                                   didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}

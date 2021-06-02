//
//  WeatherMainViewController.swift
//  Weather
//
//  Created by Егор Никитин on 04.05.2021.
//

import UIKit

enum MainWeatherControllerState {
    case currentLocationWeather
    case selectedCityWeather
    case emptyWithPlus
}

final class WeatherMainViewController: UIViewController {
    
    //MARK: - Properties

    var coordinator: WeatherMainCoordinator?
    
    private var stateViewController: MainWeatherControllerState
    
    private var xPoint: CGFloat = 0.0
    
    private var viewModelOutput: WeatherMainViewModelOutput
    
    var currentPage: Int? {
        didSet {
            pageControl.currentPage = currentPage ?? 0
        }
    }
    
    var numberOfPages: Int? {
        didSet {
            pageControl.numberOfPages = numberOfPages ?? 1
        }
    }
    
    var weatherPageViewController: WeatherPageViewController?
    
    private lazy var menuView: MenuView = {
        $0.frame = CGRect(x: -(UIScreen.main.bounds.width - 75), y: 0, width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.height - 44)
        $0.isHidden = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        $0.addGestureRecognizer(panGestureRecognizer)
        return $0
    }(MenuView())
    
    private lazy var blurView: UIView = {
        $0.backgroundColor = UIColor(red: 0.175, green: 0.163, blue: 0.163, alpha: 1)
        $0.alpha = 0
        $0.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIView())
    
    private lazy var cityNameLabel: UILabel = {
        $0.textColor = .white
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
        $0.addTarget(self, action: #selector(useGeolocationButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    private lazy var pageControl: CustomPageControl = {
        $0.currentPageImage = UIImage(named: "CircleFill")!
        $0.otherPagesImage = UIImage(named: "Circle")!
        $0.addTarget(self, action: #selector(didChangePageControlValue), for: .valueChanged)
        return $0
    }(CustomPageControl())
    
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
    
    // MARK: - Init
    
    init(viewModel: WeatherMainViewModelOutput, stateViewController: MainWeatherControllerState) {
        self.viewModelOutput = viewModel
        self.stateViewController = stateViewController
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWeatherData()
        checkTracingSettingsChanges()
        if menuView.isHidden == false {
            menuView.frame.origin.x = -(UIScreen.main.bounds.width - 75)
            menuView.isHidden = true
            blurView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelOutput.onLoadData?(stateViewController, currentPage ?? 0)
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
        updateWeatherData()
        getWeatherData()
        getCityName()
        onEditTapped()
    }

    //MARK: - Methods

    private func getWeatherData() {
        viewModelOutput.onWeatherLoaded = { bool in
            if bool {
                self.updateWeatherData()
            } else {
                self.coordinator?.showNetworkAlert()
            }
        }
    }
    
    private func getCityName() {
        viewModelOutput.onCityLoaded = { (bool, name) in
            if bool {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 1.03
                guard let cityName = name else {
                    return
                }
                self.cityNameLabel.attributedText = NSMutableAttributedString(string: cityName, attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                self.cityNameLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
            } else {
                self.coordinator?.showNetworkAlert()
            }
        }
    }
    
    private func updateWeatherData() {
        if let cityName = viewModelOutput.configureCityName() {
            cityNameLabel.attributedText = cityName
            cityNameLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        }
        mainWeatherInformationView.viewConfigure = viewModelOutput.configureMainInformationView()
        hourlyForecastCollectionView.reloadData()
        dailyForecastCollectionView.reloadData()
        menuView.configureMenu = viewModelOutput.configureMenuView()
    }
    
    private func checkTracingSettingsChanges() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isTrackingBoolKey.rawValue)
            && UserDefaults.standard.bool(forKey: UserDefaultsKeys.isTrackingSettingsChanged.rawValue)
            && !RealmDataManager.sharedInstance.isRealmContainsCurrentLocationCachedWeather() {
            /// insert viewController to ordered and data in realm
            let newViewController = FlowFactory.makeWeatherMainViewController(coordinator: self.coordinator, stateViewController: .currentLocationWeather, pageViewController: self.weatherPageViewController)
            self.weatherPageViewController?.insertLocationWeatherMainViewController(weatherMainViewController: newViewController)
            UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.isTrackingSettingsChanged.rawValue)
            
        } else if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isTrackingBoolKey.rawValue)
                    && UserDefaults.standard.bool(forKey: UserDefaultsKeys.isTrackingSettingsChanged.rawValue) {
            /// remove viewController from ordered and data in realm
            self.weatherPageViewController?.deleteLocationWeatherMainViewController()
            UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.isTrackingSettingsChanged.rawValue)
        }
    }
    
    private func changeStateVC() {
        stateViewController = .selectedCityWeather
        plusImage.isHidden = true
        mainWeatherInformationView.isHidden = false
        detailsLabel.isHidden = false
        hourlyForecastCollectionView.isHidden = false
        dailyForecastLabel.isHidden = false
        daysCountLabel.isHidden = false
        dailyForecastCollectionView.isHidden = false
    }
    
    @objc func plusImageTapped() {
        let alertController = UIAlertController(title: "Введите название города для отображения погоды", message: nil, preferredStyle: .alert)
        alertController.addTextField { (text) in
            text.placeholder = "название города"
        }
        let alertActionFind = UIAlertAction(title: "ОК", style: .default) { [weak self] (alert) in
            guard let self = self else { return }
            let cityName = alertController.textFields?[0].text
            if let name = cityName, name != "" {
                self.viewModelOutput.onLoadNewCityWeather?(name)
                self.changeStateVC()
                let weatherMainViewController = FlowFactory.makeWeatherMainViewController(coordinator: self.coordinator, stateViewController: .emptyWithPlus, pageViewController: self.weatherPageViewController)
                self.weatherPageViewController?.appendNewViewController(newViewController: weatherMainViewController)
            }
            
        }
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(alertActionFind)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
    }

    //MARK: - Actions
    
    private func onEditTapped() {
        menuView.onEditTapped = {
            self.coordinator?.pushSettingsViewController()
        }
    }

    @objc func didChangePageControlValue() {
        weatherPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    @objc private func blurViewTapped() {
        UIView.animate(withDuration: 0.25) {
            self.menuView.frame.origin.x = -(UIScreen.main.bounds.width - 75)
            self.blurView.alpha = 0
        } completion: { (bool) in
            self.menuView.isHidden = true
            self.blurView.isHidden = true
        }
    }
    
    @objc private func pan(panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .began {
            xPoint = menuView.frame.origin.x
        }
        
        panGestureRecognizer.translation(in: self.view)
        
        let xCoordinate = panGestureRecognizer.translation(in: self.view).x
        
        if xCoordinate < 0.0 {
            let newXPoint = xPoint + xCoordinate
            menuView.frame.origin.x = newXPoint
        }

        if panGestureRecognizer.state == .ended {
            if xCoordinate < -(menuView.frame.width / 4) {
                UIView.animate(withDuration: 0.25) {
                    self.menuView.frame.origin.x = -(UIScreen.main.bounds.width - 75)
                    self.blurView.alpha = 0
                } completion: { (bool) in
                    self.menuView.isHidden = true
                    self.blurView.isHidden = true
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.menuView.frame.origin.x = 0.0
                }
            }
            
        }
    }
    
    @objc private func openSettings() {
        menuView.isHidden = false
        blurView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.menuView.frame.origin.x = 0
            self.blurView.alpha = 0.7
        }
    }
    
    @objc private func useGeolocationButtonTapped() {
        coordinator?.pushGeolocationViewController()
    }
    
    @objc private func detailsLabelTapped() {
        coordinator?.pushHourlyWeatherViewController(cachedWeather: viewModelOutput.cachedWeather)
    }
    
    @objc private func daysCountLabelTapped() {
        print("daysCountLabel Tap")
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
    }

    //MARK: - Setup layout

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
        view.addSubview(blurView)
        view.addSubview(menuView)
        
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
        
        blurView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(bottomSafeArea.snp.top)
        }
    }
    
}

//MARK: - UICollectionViewDataSource and UICollectionViewDelegateFlowLayout

extension WeatherMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyForecastCollectionView {
            return viewModelOutput.getHourlyWeatherArray().count
        }
        return viewModelOutput.getDailyWeatherArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyForecastCollectionView {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyForecastCollectionViewCell.self), for: indexPath) as! HourlyForecastCollectionViewCell
            let hurlyWeatherArray = viewModelOutput.getHourlyWeatherArray()
            let hourlyWeather = hurlyWeatherArray[indexPath.item]
            if indexPath.item == 1 {
                item.prepareForReuse()
                item.configureSelectedItem()
            }
            item.configure = viewModelOutput.configureHourlyItem(with: hourlyWeather)
            return item
        }
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DailyForecastCollectionViewCell.self), for: indexPath) as! DailyForecastCollectionViewCell
        let dailyWeatherArray = viewModelOutput.getDailyWeatherArray()
        let dailyWeather = dailyWeatherArray[indexPath.item]
        item.configure = viewModelOutput.configureDailyItem(with: dailyWeather)
        return item
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == hourlyForecastCollectionView {
            return CGSize(width: 42, height: 83)
        }
        return CGSize(width: collectionView.frame.width - 16 - 15, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == hourlyForecastCollectionView {
            //
        } else if collectionView == dailyForecastCollectionView {
            let index = indexPath.item
            coordinator?.pushDailyWeatherViewController(cachedWeather: viewModelOutput.cachedWeather, selectedIndex: index + 1)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == hourlyForecastCollectionView {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        return UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 15)
    }
}

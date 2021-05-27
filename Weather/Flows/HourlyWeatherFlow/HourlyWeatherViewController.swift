//
//  HourlyWeatherViewController.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

final class HourlyWeatherViewController: UIViewController {
    
    //MARK: - Properties
    
    var coordinator: HourlyWeatherCoordinator?
    
    private var viewModelOutput: HourlyWeatherViewModelOutput
    
    private lazy var backButton: UIButton = {
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        $0.setBackgroundImage(UIImage(named: "ArrowLeft"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.attributedText = NSMutableAttributedString(string: "Прогноз на 24 часа", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var cityNameLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var scrollView: UIScrollView = {
        return $0
    }(UIScrollView())
    
    private lazy var chartView: ChartView = {
        $0.backgroundColor = AppColors.sharedInstance.accentLightBlue
        return $0
    }(ChartView(hourlyWeather: viewModelOutput.getHourlyWeatherArray(), timezoneOffset: viewModelOutput.getTimezoneOffset().timezoneOffset, moscowTimeOffset: viewModelOutput.getTimezoneOffset().moscowTimeOffset))
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var bottomSafeArea: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.accentBlue
        return $0
    }(UIView())
    
    private var reuseID: String {
        return String(describing: HourlyTableViewCell.self)
    }
    
    
    //MARK: - Init
    
    init(viewModel: HourlyWeatherViewModelOutput) {
        self.viewModelOutput = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        coordinator?.didFinishHourlyWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
 
        setupLayout()
        
        setupTableView()
        
        cityNameLabel.attributedText = viewModelOutput.configureCityName()
    }
    
    //MARK: - Actions
    
    @objc private func backButtonTapped() {
        coordinator?.popToWeatherMainViewController()
    }
    
    //MARK: - Setup layout
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.separatorColor = AppColors.sharedInstance.dividerColor
    }
    
    private func setupLayout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(cityNameLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(chartView)
        view.addSubview(tableView)
        view.addSubview(bottomSafeArea)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(48)
            make.leading.equalToSuperview().offset(52)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-20)
            make.width.equalTo(15)
            make.height.equalTo(8)
        }
        
        cityNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(48)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(152)
        }
        
        chartView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(scrollView.snp.height)
            make.width.equalTo(430)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
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

//MARK: - UITableViewDataSource

extension HourlyWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelOutput.getHourlyWeatherArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HourlyTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! HourlyTableViewCell
        let hoursArray = viewModelOutput.getHourlyWeatherArray()
        let hour = hoursArray[indexPath.row]
        cell.configure = viewModelOutput.configureHourlyCell(with: hour)
        cell.selectionStyle = .none
        return cell
    }
    
    
}

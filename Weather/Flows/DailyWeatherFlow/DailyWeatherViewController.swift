//
//  DailyWeatherFlow.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

final class DailyWeatherViewController: UIViewController {
    
    var coordinator: DailyWeatherCoordinator?
    
    private var viewModelOutput: DailyWeatherViewModelOutput
    
    private lazy var topSafeArea: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.black
        return $0
    }(UIView())
    
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
        $0.attributedText = NSMutableAttributedString(string: "Дневная погода", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var cityNameLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        $0.textAlignment = .right
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.attributedText = NSMutableAttributedString(string: "Cан-Франциско,США", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var daysCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        collection.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DayCollectionViewCell.self))
        collection.dataSource = self
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var bottomSafeArea: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.accentBlue
        return $0
    }(UIView())
    
    
    // Mark: - init
    
    init(viewModel: DailyWeatherViewModelOutput) {
        self.viewModelOutput = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
        coordinator?.didFinishDailyWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        setupLayout()
        
        setupTableView()
        
    }
    
    @objc private func backButtonTapped() {
        coordinator?.popToWeatherMainViewController()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        //            tableView.register(PeriodsOfTimeTableViewCell.self, forCellReuseIdentifier: periodsOfTimeReuseID)
        //            tableView.register(SunAndMoonTableViewCell.self, forCellReuseIdentifier: sunAndMoonReuseId)
    }
    
    
    private func setupLayout() {
        view.addSubview(topSafeArea)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(cityNameLabel)
        view.addSubview(daysCollectionView)
        view.addSubview(tableView)
        view.addSubview(bottomSafeArea)
        
        topSafeArea.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topSafeArea.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(49)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-20)
            make.width.equalTo(12)
            make.height.equalTo(8)
        }
        
        cityNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(16)
        }
        
        daysCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(36)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(daysCollectionView.snp.bottom).offset(20)
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


extension DailyWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModelOutput.getDailyWeatherArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DayCollectionViewCell.self), for: indexPath) as! DayCollectionViewCell
        let daysArray = viewModelOutput.getDailyWeatherArray()
        let day = daysArray[indexPath.item]
        item.configure = viewModelOutput.configureDayItem(with: day)
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 88, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
//        if cell.isSelected {
//            cell.configureSelectedItem()
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell {
//            if !cell.isSelected {
//                cell.configureUnselectedItem()
//            }
//        }
//    }
    
    
}


extension DailyWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

//
//  HourlyForecastCollectionViewCell.swift
//  Weather
//
//  Created by Егор Никитин on 11.05.2021.
//

import UIKit

final class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    var cellConfigure: String? {
        didSet {
            
        }
    }
    
    private lazy var timeLabel: UILabel = {
        $0.textColor = UIColor(red: 0.613, green: 0.592, blue: 0.592, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 12)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.27
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "12:00", attributes: [NSAttributedString.Key.kern: 0.24, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var temperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 0.204, green: 0.187, blue: 0.187, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.95
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "15º", attributes: [NSAttributedString.Key.kern: 0.32, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var weatherImage: UIImageView = {
        $0.image = UIImage(named: "Sun")
        return $0
    }(UIImageView())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configure(with object: Current) {
//        temperatureLabel.text = "\(Int(object.temp))°"
//        setupTimeLabel(time: object.dt)
//        setupWeatherImage(weather: object.weather.first?.main.rawValue)
//    }
    
    func configureSelectedItem() {
        contentView.backgroundColor = AppColors.sharedInstance.accentBlue
        timeLabel.textColor = .white
        temperatureLabel.textColor = .white
    }
    
    func configureUnselectedItem() {
        contentView.backgroundColor = .white
        timeLabel.textColor = UIColor(red: 0.613, green: 0.592, blue: 0.592, alpha: 1)
        temperatureLabel.textColor = UIColor(red: 0.204, green: 0.187, blue: 0.187, alpha: 1)
    }
    
    private func setupCellView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 22
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor(red: 0.671, green: 0.737, blue: 0.918, alpha: 1).cgColor
    }
    
    private func setupLayout() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(temperatureLabel)
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        weatherImage.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        temperatureLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-7)
            make.centerX.equalToSuperview()
        }
    }
}

//
//  DaylyForecastCollectionViewCell.swift
//  Weather
//
//  Created by Егор Никитин on 11.05.2021.
//

import UIKit

final class DailyForecastCollectionViewCell: UICollectionViewCell {
    
    var configure: (dayDate: String, image: UIImage?, humidity: String, descriptionWeather: String, temperature: String)? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.05
            dateLabel.attributedText = NSMutableAttributedString(string: configure?.dayDate ?? "06/07", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            weatherImage.image = configure?.image
            paragraphStyle.lineHeightMultiple = 1.13
            humidityLabel.attributedText = NSMutableAttributedString(string: configure?.humidity ?? "0%", attributes: [NSAttributedString.Key.kern: -0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            paragraphStyle.lineHeightMultiple = 1.05
            descriptionWeatherLabel.attributedText = NSMutableAttributedString(string: configure?.descriptionWeather ?? "...", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            paragraphStyle.lineHeightMultiple = 1.08
            temperatureLabel.attributedText = NSMutableAttributedString(string: configure?.temperature ?? "0º -0º", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
    private lazy var dateLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.attributedText = NSMutableAttributedString(string: "06/07", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var weatherImage: UIImageView = {
        $0.image = UIImage(named: "CloudRain")
        return $0
    }(UIImageView())
    
    private lazy var humidityLabel: UILabel = {
        $0.textColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 12)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13
        $0.attributedText = NSMutableAttributedString(string: "0%", attributes: [NSAttributedString.Key.kern: -0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var descriptionWeatherLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.attributedText = NSMutableAttributedString(string: "...", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var temperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        $0.attributedText = NSMutableAttributedString(string: "0º -0º", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var chevronImage: UIImageView = {
        $0.image = UIImage(named: "Chevron")
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
    
    private func setupCellView() {
        contentView.backgroundColor = AppColors.sharedInstance.accentLightBlue
        contentView.layer.cornerRadius = 5
    }
    
    private func setupLayout() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(descriptionWeatherLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(chevronImage)

        dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(10)
        }

        weatherImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-9.24)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(15)
            make.height.equalTo(17.08)
        }

        humidityLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(weatherImage.snp.trailing).offset(5)
            make.centerY.equalTo(weatherImage)
        }
        
        descriptionWeatherLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(66)
            make.centerY.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-26)

        }

        chevronImage.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(6)
            make.height.equalTo(9.49)
        }
    }
}

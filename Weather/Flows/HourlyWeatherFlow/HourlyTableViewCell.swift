//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Егор Никитин on 21.05.2021.
//

import UIKit

final class HourlyTableViewCell: UITableViewCell {
    
    var configure: HourlyWeather? {
        didSet {
            dateLabel.attributedText = configure?.date
            timeLabel.attributedText = configure?.time
            temperatureLabel.attributedText = configure?.temperature
            weatherImage.image = configure?.weatherImage
            weatherDescriptionLabel.attributedText = configure?.weatherDescription
            windInfoLabel.attributedText = configure?.windSpeed
            precipitationInfoLabel.attributedText = configure?.precipitation
            cloudinessInfoLabel.attributedText = configure?.cloudiness
        }
    }
    
    private lazy var dateLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        return $0
    }(UILabel())
    
    private lazy var timeLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())
    
    private lazy var temperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        return $0
    }(UILabel())
    
    private lazy var weatherImage: UIImageView = {
        return $0
    }(UIImageView())
    
    private lazy var weatherDescriptionLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())
    
    private lazy var windImage: UIImageView = {
        $0.image = UIImage(named: "WindSpeed")
        return $0
    }(UIImageView())
    
    private lazy var windLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Ветер", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var windInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())
    
    private lazy var  precipitationImage: UIImageView = {
        $0.image = UIImage(named: "Drops")
        return $0
    }(UIImageView())
    
    private lazy var precipitationLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Атмосферные осадки", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var precipitationInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())
    
    private lazy var cloudinessImage: UIImageView = {
        $0.image = UIImage(named: "Cloud")
        return $0
    }(UIImageView())
    
    private lazy var cloudinessLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.96
        $0.attributedText = NSMutableAttributedString(string: "Облачность", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var cloudinessInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = AppColors.sharedInstance.accentLightBlue
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(weatherDescriptionLabel)
        contentView.addSubview(windImage)
        contentView.addSubview(windLabel)
        contentView.addSubview(windInfoLabel)
        contentView.addSubview(precipitationImage)
        contentView.addSubview(precipitationLabel)
        contentView.addSubview(precipitationInfoLabel)
        contentView.addSubview(cloudinessImage)
        contentView.addSubview(cloudinessLabel)
        contentView.addSubview(cloudinessInfoLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(16)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        temperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(22)
        }
        
        weatherDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(90)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        weatherImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(weatherDescriptionLabel)
            make.trailing.equalTo(weatherDescriptionLabel.snp.leading).offset(-4.5)
            make.width.equalTo(11.11)
            make.height.equalTo(12)
        }
        
        windLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(92)
        }
        
        windImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(windLabel)
            make.trailing.equalTo(windLabel.snp.leading).offset(-3)
            make.width.equalTo(15)
            make.height.equalTo(10)
        }
        
        windInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(windLabel)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        precipitationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(windLabel.snp.bottom).offset(8)
            make.leading.equalTo(windLabel.snp.leading)
        }
        
        precipitationImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(precipitationLabel)
            make.trailing.equalTo(precipitationLabel.snp.leading).offset(-7)
            make.width.equalTo(11)
            make.height.equalTo(13)
        }
        
        precipitationInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(precipitationLabel)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        cloudinessLabel.snp.makeConstraints { (make) in
            make.top.equalTo(precipitationLabel.snp.bottom).offset(8)
            make.leading.equalTo(windLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        cloudinessImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(cloudinessLabel)
            make.trailing.equalTo(windLabel.snp.leading).offset(-4)
            make.width.equalTo(14)
            make.height.equalTo(7.28)
        }
        
        cloudinessInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(cloudinessLabel)
            make.trailing.equalToSuperview().offset(-15)
        }
    }

}

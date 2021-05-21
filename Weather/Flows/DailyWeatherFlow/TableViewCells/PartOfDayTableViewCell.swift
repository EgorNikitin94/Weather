//
//  PartOfDayTableViewCell.swift
//  Weather
//
//  Created by Егор Никитин on 19.05.2021.
//

import UIKit

final class PartOfDayTableViewCell: UITableViewCell {
    
    var configure: Day? {
        didSet {
            partOfDay.attributedText = configure?.dayPart
            weatherImage.image = configure?.weatherImage
            temperatureLabel.attributedText = configure?.temperature
            descriptionLabel.attributedText = configure?.temperatureDescription
            feelsImage.image = configure?.thermometerImage
            feelsTempLabel.attributedText = configure?.feelsTemperature
            windInfoLabel.attributedText = configure?.windSpeed
            uvInfoLabel.attributedText = configure?.uv
            precipitationInfoLabel.attributedText = configure?.precipitation
            cloudinessInfoLabel.attributedText = configure?.cloudiness
        }
    }
    
    private lazy var partOfDay: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        return $0
    }(UILabel())
    
    private lazy var weatherImage: UIImageView = {
        return $0
    }(UIImageView())
    
    private lazy var temperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 30)
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        return $0
    }(UILabel())
    
    private lazy var feelsImage: UIImageView = {
        return $0
    }(UIImageView())
    
    private lazy var feelsLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "По ощущениям", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var feelsTempLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var firstDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
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
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var secondDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var uvImage: UIImageView = {
        $0.image = UIImage(named: "Sun2")
        return $0
    }(UIImageView())
    
    private lazy var uvLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Уф индекс", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var uvInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var thirdDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var precipitationImage: UIImageView = {
        $0.image = UIImage(named: "CloudRain")
        return $0
    }(UIImageView())
    
    private lazy var precipitationLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Дождь", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var precipitationInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var fourthDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var cloudinessImage: UIImageView = {
        $0.image = UIImage(named: "Cloud")
        return $0
    }(UIImageView())
    
    private lazy var cloudinessLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Облачность", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var cloudinessInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var fifthDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var containerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.accentLightBlue
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = AppColors.sharedInstance.accentLightBlue
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(partOfDay)
        contentView.addSubview(containerView)
        containerView.addSubview(weatherImage)
        containerView.addSubview(temperatureLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(feelsImage)
        contentView.addSubview(feelsLabel)
        contentView.addSubview(feelsTempLabel)
        contentView.addSubview(firstDividerView)
        contentView.addSubview(windImage)
        contentView.addSubview(windLabel)
        contentView.addSubview(windInfoLabel)
        contentView.addSubview(secondDividerView)
        contentView.addSubview(uvImage)
        contentView.addSubview(uvLabel)
        contentView.addSubview(uvInfoLabel)
        contentView.addSubview(thirdDividerView)
        contentView.addSubview(precipitationImage)
        contentView.addSubview(precipitationLabel)
        contentView.addSubview(precipitationInfoLabel)
        contentView.addSubview(fourthDividerView)
        contentView.addSubview(cloudinessImage)
        contentView.addSubview(cloudinessLabel)
        contentView.addSubview(cloudinessInfoLabel)
        contentView.addSubview(fifthDividerView)
        
        partOfDay.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(21)
            make.leading.equalToSuperview().offset(15)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(72)
            make.height.equalTo(36)
        }
        
        weatherImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
            make.width.equalTo(26)
            make.height.equalTo(30)
        }
        
        temperatureLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        
        feelsImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(feelsLabel)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(24)
            make.height.equalTo(26)
        }
        
        feelsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            make.leading.equalTo(feelsImage.snp.trailing).offset(15)
        }
        
        feelsTempLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(feelsLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        firstDividerView.snp.makeConstraints { (make) in
            make.top.equalTo(feelsLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        windImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(windLabel)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(24)
            make.height.equalTo(14)
        }
        
        windLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstDividerView.snp.bottom).offset(13)
            make.leading.equalTo(windImage.snp.trailing).offset(15)
        }
        
        windInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(windLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        secondDividerView.snp.makeConstraints { (make) in
            make.top.equalTo(windLabel.snp.bottom).offset(13)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        uvImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(uvLabel)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        uvLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondDividerView.snp.bottom).offset(13)
            make.leading.equalTo(uvImage.snp.trailing).offset(15)
        }
        
        uvInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(uvLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        thirdDividerView.snp.makeConstraints { (make) in
            make.top.equalTo(uvLabel.snp.bottom).offset(13)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        precipitationImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(precipitationLabel)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(24)
            make.height.equalTo(30)
        }
        
        precipitationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdDividerView.snp.bottom).offset(10)
            make.leading.equalTo(precipitationImage.snp.trailing).offset(15)
        }
        
        precipitationInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(precipitationLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        fourthDividerView.snp.makeConstraints { (make) in
            make.top.equalTo(precipitationLabel.snp.bottom).offset(17)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        cloudinessImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(cloudinessLabel)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(24)
            make.height.equalTo(12)
        }
        
        cloudinessLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fourthDividerView.snp.bottom).offset(10)
            make.leading.equalTo(cloudinessImage.snp.trailing).offset(15)
        }
        
        cloudinessInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(cloudinessLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        fifthDividerView.snp.makeConstraints { (make) in
            make.top.equalTo(cloudinessLabel.snp.bottom).offset(17)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
}

//
//  MainWeatherInfornationView.swift
//  Weather
//
//  Created by Егор Никитин on 09.05.2021.
//

import UIKit

final class MainWeatherInformationView: UIView {
    
    //MARK: - Configure
    
    var viewConfigure: (dailyTemperature: String, currentTemperature: String, descriptionWeather: String, cloudy: String, windSpeed: String, humidity: String, sunrise: String, sunset: String, currentDate: String)? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.05
            dailyTemperatureLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.dailyTemperature ?? "0", attributes: [NSAttributedString.Key.kern: 0.32, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            paragraphStyle.lineHeightMultiple = 0.94
            currentTemperatureLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.currentTemperature ?? "0", attributes: [NSAttributedString.Key.kern: 3.06, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            descriptionWeatherLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.descriptionWeather ?? "", attributes: [NSAttributedString.Key.kern: 3.06, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            paragraphStyle.lineHeightMultiple = 1.08
            cloudyLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.cloudy ??  "0", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            windSpeedLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.windSpeed ??  "0 м/с", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            humidityLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.humidity ??  "0%", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            paragraphStyle.lineHeightMultiple = 1.15
            sunriseLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.sunrise ?? "0:00", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            sunsetLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.sunset ?? "0:00", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            paragraphStyle.lineHeightMultiple = 1.15
            currentDateLabel.attributedText = NSMutableAttributedString(string: viewConfigure?.currentDate ?? "", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
    //MARK: - Properties
    
    private lazy var ellipseImage: UIImageView = {
        $0.image = UIImage(named: "Ellipse")
        $0.contentMode = .scaleToFill
        return $0
    }(UIImageView())
    
    private lazy var dailyTemperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.attributedText = NSMutableAttributedString(string: "0º /0º", attributes: [NSAttributedString.Key.kern: 0.32, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var currentTemperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 36)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.94
        $0.attributedText = NSMutableAttributedString(string: "0º", attributes: [NSAttributedString.Key.kern: 3.06, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var descriptionWeatherLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.94
        $0.attributedText = NSMutableAttributedString(string: "...", attributes: [NSAttributedString.Key.kern: 3.06, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var smallContainerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.accentBlue
        return $0
    }(UIView())
    
    private lazy var windyContainerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.accentBlue
        return $0
    }(UIView())
    
    private lazy var cloudyImage: UIImageView = {
        $0.image = UIImage(named: "Cloudy")
        return $0
    }(UIImageView())
    
    private lazy var cloudyLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        $0.attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var windSpeedImage: UIImageView = {
        $0.image = UIImage(named: "WindSpeed")
        return $0
    }(UIImageView())
    
    private lazy var windSpeedLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        $0.attributedText = NSMutableAttributedString(string: "0 м\\с", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var humidityImage: UIImageView = {
        $0.image = UIImage(named: "Drops")
        return $0
    }(UIImageView())
    
    private lazy var humidityLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        $0.attributedText = NSMutableAttributedString(string: "0%", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var sunriseImage: UIImageView = {
        $0.image = UIImage(named: "Sunrise")
        return $0
    }(UIImageView())
    
    private lazy var sunriseLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "0:00", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var sunsetImage: UIImageView = {
        $0.image = UIImage(named: "Sunset")
        return $0
    }(UIImageView())
    
    private lazy var sunsetLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "00:00", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var currentDateLabel: UILabel = {
        $0.textColor = AppColors.sharedInstance.yellow
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "...", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    //MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = AppColors.sharedInstance.accentBlue
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup layout
    
    private func setupLayout() {
        self.addSubview(ellipseImage)
        self.addSubview(dailyTemperatureLabel)
        self.addSubview(currentTemperatureLabel)
        self.addSubview(descriptionWeatherLabel)
        self.addSubview(smallContainerView)
        smallContainerView.addSubview(cloudyImage)
        smallContainerView.addSubview(cloudyLabel)
        smallContainerView.addSubview(windyContainerView)
        windyContainerView.addSubview(windSpeedImage)
        windyContainerView.addSubview(windSpeedLabel)
        smallContainerView.addSubview(humidityImage)
        smallContainerView.addSubview(humidityLabel)
        self.addSubview(sunriseImage)
        self.addSubview(sunriseLabel)
        self.addSubview(sunsetImage)
        self.addSubview(sunsetLabel)
        self.addSubview(currentDateLabel)
        
        dailyTemperatureLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(33)
            make.centerX.equalToSuperview().offset(3)
        }
        
        currentTemperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dailyTemperatureLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(1.5)
        }
        
        descriptionWeatherLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        smallContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionWeatherLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(78)
            make.trailing.equalToSuperview().offset(-78)
        }
        
        cloudyImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(21)
            make.height.equalTo(18)
        }
        
        cloudyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(cloudyImage)
            make.leading.equalTo(cloudyImage.snp.trailing).offset(5)
        }
        
        windyContainerView.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        windSpeedImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(16)
        }
        
        windSpeedLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(windSpeedImage.snp.trailing).offset(5)
            make.centerY.equalTo(windSpeedImage)
            make.trailing.equalToSuperview()
        }
        
        humidityLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        humidityImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(humidityLabel)
            make.trailing.equalTo(humidityLabel.snp.leading).offset(-5)
            make.width.equalTo(13)
            make.height.equalTo(15)
        }
        
        sunriseImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(25)
            make.width.equalTo(17)
            make.height.equalTo(17)
        }
        
        sunriseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sunriseImage.snp.bottom).offset(5)
            //make.centerX.equalTo(sunriseImage)
            make.leading.equalToSuperview().offset(17)
        }
        
        sunsetImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview().offset(-25)
            make.width.equalTo(17)
            make.height.equalTo(17)
        }
        
        sunsetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sunsetImage.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-14)
        }
        
        currentDateLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-21)
            make.centerX.equalToSuperview()
        }
        
        ellipseImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().offset(33)
            make.trailing.equalToSuperview().offset(-31)
            make.bottom.equalTo(sunriseImage.snp.top).offset(-5)
        }
    }
}

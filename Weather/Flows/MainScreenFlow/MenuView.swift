//
//  MenuView.swift
//  Weather
//
//  Created by Егор Никитин on 27.05.2021.
//

import UIKit

final class MenuView: UIView {
    
    //MARK: - Configure
    
    var configureMenu: (cityName: NSMutableAttributedString, isOnNotifications: Bool, isDailyShow: Bool, temperatureUnit: NSMutableAttributedString, windSpeedUnit: NSMutableAttributedString, visibilityUnit: NSMutableAttributedString, timeFormat: NSMutableAttributedString)? {
        didSet {
            geolocationLabel.attributedText = configureMenu?.cityName
            notificationSwitch.isSelected = configureMenu?.isOnNotifications ?? false
            dailyWeatherSwitch.isSelected = configureMenu?.isDailyShow ?? false
            temperatureInfoLabel.attributedText = configureMenu?.temperatureUnit
            windSpeedInfoLabel.attributedText = configureMenu?.windSpeedUnit
            visibilityInfoLabel.attributedText = configureMenu?.visibilityUnit
            timeFormatInfoLabel.attributedText = configureMenu?.timeFormat
        }
    }
    
    //MARK: - Properties
    
    var onEditTapped: (() -> Void)?
    
    private lazy var smallWeatherIconImage: UIImageView = {
        $0.image = UIImage(named: "Cloudy")
        return $0
    }(UIImageView())
    
    private lazy var weatherLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.attributedText = NSMutableAttributedString(string: "Погода", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var editImage: UIImageView = {
        $0.image = UIImage(named: "Edit")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIImageView())
    
    private lazy var editLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Редактировать ", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UILabel())
    
    private lazy var geolocationImage: UIImageView = {
        $0.image = UIImage(named: "MarkWhite")
        return $0
    }(UIImageView())
    
    private lazy var geolocationLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())

    private lazy var notificationImage: UIImageView = {
        $0.image = UIImage(named: "Bal")
        return $0
    }(UIImageView())
    
    private lazy var notificationLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Уведомление", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var notificationSwitch: CustomSwitch = {
        return $0
    }(CustomSwitch(isSelected: UserDefaults.standard.bool(forKey: UserDefaultsKeys.isNotifyBoolKey.rawValue), userDefaultsKey: UserDefaultsKeys.isNotifyBoolKey.rawValue))

    
    private lazy var dailyWeatherImage: UIImageView = {
        $0.image = UIImage(named: "Sun3")
        return $0
    }(UIImageView())
    
    private lazy var dailyWeatherLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Дневная погода", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var  dailyWeatherSwitch: CustomSwitch = {
        return $0
    }(CustomSwitch(isSelected: UserDefaults.standard.bool(forKey: UserDefaultsKeys.isDailyShowBoolKey.rawValue), userDefaultsKey: UserDefaultsKeys.isDailyShowBoolKey.rawValue))
    
    private lazy var temperatureImage: UIImageView = {
        $0.image = UIImage(named: "ThermometerSmall")
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private lazy var temperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Единица температуры", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var temperatureInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.934, green: 0.955, blue: 0.971, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())
    
    private lazy var windSpeedImage: UIImageView = {
        $0.image = UIImage(named: "Fan")
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private lazy var windSpeedLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Единица скорости ветра", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var windSpeedInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.934, green: 0.955, blue: 0.971, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())
    
    private lazy var visibilityImage: UIImageView = {
        $0.image = UIImage(named: "Eye")
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private lazy var visibilityLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Блок видимости", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var visibilityInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.934, green: 0.955, blue: 0.971, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())
    
    private lazy var timeFormatImage: UIImageView = {
        $0.image = UIImage(named: "Clock")
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private lazy var timeFormatLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Формат времени", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var timeFormatInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.934, green: 0.955, blue: 0.971, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        return $0
    }(UILabel())
    
    private lazy var dateFormatImage: UIImageView = {
        $0.image = UIImage(named: "Calendar")
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private lazy var dateFormatLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Формат даты", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var dateFormatInfoLabel: UILabel = {
        $0.textColor = UIColor(red: 0.934, green: 0.955, blue: 0.971, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "mm/dd/yy", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
    
    //MARK: - Draw lines
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        UIColor(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        UIColor(red: 1, green: 1, blue: 1, alpha: 1).setStroke()
        
        let path = UIBezierPath()
        
        path.lineWidth = 0.5
        
        path.move(to: CGPoint(x: 0, y: 94))
        
        path.addLine(to: CGPoint(x: self.frame.width - 18, y: 94))
        
        path.stroke()
        
        context.saveGState()
        
        let dashesPath = UIBezierPath()
        
        dashesPath.lineWidth = 0.5
        
        dashesPath.move(to: CGPoint(x: 0, y: 194))
        
        dashesPath.addLine(to: CGPoint(x: self.frame.width - 18, y: 194))
        
        let  dashes: [ CGFloat ] = [3.0, 3.0]
        dashesPath.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        dashesPath.stroke()
        
        context.saveGState()
        
    }
    
    //MARK: - Actions
    
    @objc private func editTapped() {
        onEditTapped?()
    }
    
    //MARK:- Setup layout
    
    private func setupLayout() {
        self.addSubview(smallWeatherIconImage)
        self.addSubview(weatherLabel)
        self.addSubview(editImage)
        self.addSubview(editLabel)
        self.addSubview(geolocationImage)
        self.addSubview(geolocationLabel)
        self.addSubview(notificationImage)
        self.addSubview(notificationLabel)
        self.addSubview(notificationSwitch)
        self.addSubview(dailyWeatherImage)
        self.addSubview(dailyWeatherLabel)
        self.addSubview(dailyWeatherSwitch)
        self.addSubview(temperatureImage)
        self.addSubview(temperatureLabel)
        self.addSubview(temperatureInfoLabel)
        self.addSubview(windSpeedImage)
        self.addSubview(windSpeedLabel)
        self.addSubview(windSpeedInfoLabel)
        self.addSubview(visibilityImage)
        self.addSubview(visibilityLabel)
        self.addSubview(visibilityInfoLabel)
        self.addSubview(timeFormatImage)
        self.addSubview(timeFormatLabel)
        self.addSubview(timeFormatInfoLabel)
        self.addSubview(dateFormatImage)
        self.addSubview(dateFormatLabel)
        self.addSubview(dateFormatInfoLabel)
        
        weatherLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(56)
            make.leading.equalToSuperview().offset(56)
        }
        
        smallWeatherIconImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(weatherLabel.snp.centerY)
            make.trailing.equalTo(weatherLabel.snp.leading).offset(-15)
            make.width.equalTo(25)
            make.height.equalTo(22)
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherLabel.snp.bottom).offset(34)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        editImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(editLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        geolocationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(editLabel.snp.bottom).offset(26)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        geolocationImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(geolocationLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(18)
            make.height.equalTo(25)
        }
        
        notificationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(geolocationLabel.snp.bottom).offset(62)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        notificationImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(notificationLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        notificationSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(notificationLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-23)
            make.width.equalTo(42)
            make.height.equalTo(15)
        }
        
        dailyWeatherLabel.snp.makeConstraints { (make) in
            make.top.equalTo(notificationLabel.snp.bottom).offset(21)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        dailyWeatherImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(dailyWeatherLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        dailyWeatherSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(dailyWeatherLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-23)
            make.width.equalTo(42)
            make.height.equalTo(15)
        }
        
        temperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dailyWeatherLabel.snp.bottom).offset(21)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        temperatureImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(temperatureLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        temperatureInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(temperatureLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-29)
        }
        
        windSpeedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(21)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        windSpeedImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(windSpeedLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        windSpeedInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(windSpeedLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-29)
        }
        
        visibilityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(21)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        visibilityImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(visibilityLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        visibilityInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(visibilityLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-29)
        }
        
        
        timeFormatLabel.snp.makeConstraints { (make) in
            make.top.equalTo(visibilityLabel.snp.bottom).offset(21)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        timeFormatImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeFormatLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        timeFormatInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeFormatLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-29)
        }
        
        dateFormatLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeFormatLabel.snp.bottom).offset(21)
            make.leading.equalTo(weatherLabel.snp.leading)
        }
        
        dateFormatImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateFormatLabel.snp.centerY)
            make.centerX.equalTo(smallWeatherIconImage.snp.centerX)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        dateFormatInfoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateFormatLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-29)
        }
        
    }
}

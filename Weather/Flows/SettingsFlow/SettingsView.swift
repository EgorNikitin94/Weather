//
//  SettingsView.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

final class SettingsView: UIView {
    
    var onSetupButtonTapped: (() -> Void)?
    
    private lazy var settingsLabel: UILabel = {
        $0.textColor = UIColor(red: 0.153, green: 0.153, blue: 0.133, alpha: 1)
        $0.font = UIFont(name: "Rubik-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.7
        $0.attributedText = NSMutableAttributedString(string: "Настройки", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var temperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 0.538, green: 0.513, blue: 0.513, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.attributedText = NSMutableAttributedString(string: "Температура", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var windSpeedLabel: UILabel = {
        $0.textColor = UIColor(red: 0.538, green: 0.513, blue: 0.513, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.attributedText = NSMutableAttributedString(string: "Скорость ветра", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var timeFormatLabel: UILabel = {
        $0.textColor = UIColor(red: 0.538, green: 0.513, blue: 0.513, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.attributedText = NSMutableAttributedString(string: "Формат времени", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var notificationLabel: UILabel = {
        $0.textColor = UIColor(red: 0.538, green: 0.513, blue: 0.513, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        $0.attributedText = NSMutableAttributedString(string: "Уведомления", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var setupButton: UIButton = {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.setBackgroundColor(AppColors.sharedInstance.orangeButton, forState: .normal)
        $0.setBackgroundColor(AppColors.sharedInstance.selectedColorButton, forState: .selected)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        let title = NSMutableAttributedString(string: "Установить", attributes: [NSAttributedString.Key.kern: -0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont(name: "Rubik-Regular", size: 16) as Any, NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        $0.setAttributedTitle(title, for: .normal)
        $0.addTarget(self, action: #selector(setupButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let temperatureSegmentedControl: CustomSegmentedControl = CustomSegmentedControl(leftSideText: "C", rightSideText: "F", userDefaultsKey: UserDefaultsKeys.isCelsiusChosenBoolKey.rawValue)
    
    private let windSpeedSegmentedControl: CustomSegmentedControl = CustomSegmentedControl(leftSideText: "MI", rightSideText: "Km", userDefaultsKey: UserDefaultsKeys.isMiChosenBoolKey.rawValue)
    
    private let timeFormatSegmentedControl: CustomSegmentedControl = CustomSegmentedControl(leftSideText: "12", rightSideText: "24", userDefaultsKey: UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue)
    
    private let notificationSegmentedControl: CustomSegmentedControl = CustomSegmentedControl(leftSideText: "On", rightSideText: "Off", userDefaultsKey: UserDefaultsKeys.isNotifyBoolKey.rawValue)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = AppColors.sharedInstance.accentLightBlue
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func setupButtonTapped() {
            onSetupButtonTapped?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        temperatureSegmentedControl.layer.cornerRadius = 5
        temperatureSegmentedControl.clipsToBounds = true
        windSpeedSegmentedControl.layer.cornerRadius = 5
        windSpeedSegmentedControl.clipsToBounds = true
        timeFormatSegmentedControl.layer.cornerRadius = 5
        timeFormatSegmentedControl.clipsToBounds = true
        notificationSegmentedControl.layer.cornerRadius = 5
        notificationSegmentedControl.clipsToBounds = true
    }
    
    private func setupLayout() {
        self.addSubview(settingsLabel)
        self.addSubview(temperatureLabel)
        self.addSubview(windSpeedLabel)
        self.addSubview(timeFormatLabel)
        self.addSubview(notificationLabel)
        self.addSubview(setupButton)
        self.addSubview(temperatureSegmentedControl)
        self.addSubview(windSpeedSegmentedControl)
        self.addSubview(timeFormatSegmentedControl)
        self.addSubview(notificationSegmentedControl)
        
        settingsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(27)
            make.leading.equalToSuperview().offset(20)
        }
        
        temperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(settingsLabel.snp.bottom).offset(20)
            make.leading.equalTo(settingsLabel.snp.leading)
        }
        
        windSpeedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(30)
            make.leading.equalTo(settingsLabel.snp.leading)
        }
        
        timeFormatLabel.snp.makeConstraints { (make) in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(30)
            make.leading.equalTo(settingsLabel.snp.leading)
        }
        
        notificationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeFormatLabel.snp.bottom).offset(30)
            make.leading.equalTo(settingsLabel.snp.leading)
        }
        
        setupButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-35)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        temperatureSegmentedControl.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalTo(temperatureLabel)
        }
        
        windSpeedSegmentedControl.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalTo(windSpeedLabel)
        }
        
        timeFormatSegmentedControl.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalTo(timeFormatLabel)
        }
        
        notificationSegmentedControl.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalTo(notificationLabel)
        }
    }
    
}

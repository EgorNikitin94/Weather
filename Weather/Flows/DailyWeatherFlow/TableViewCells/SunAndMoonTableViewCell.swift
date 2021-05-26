//
//  SunAndMoonTableViewCell.swift
//  Weather
//
//  Created by Егор Никитин on 19.05.2021.
//

import UIKit

final class SunAndMoonTableViewCell: UITableViewCell {
    
    var configure: SunAndMoonPhase? {
        didSet {
            moonPhaseLabel.attributedText = configure?.moonPhase
            dayDurationLabel.attributedText = configure?.dayDuration
            nightDurationLabel.attributedText = configure?.nightDuration
            sunriseTimeLabel.attributedText = configure?.sunriseTime
            moonriseTimeLabel.attributedText = configure?.moonriseTime
            sunsetTimeLabel.attributedText = configure?.sunsetTime
            moonsetTimeLabel.attributedText = configure?.moonsetTime
        }
    }
    
    private lazy var sunAndMoonLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.attributedText = NSMutableAttributedString(string: "Солнце и Луна", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var  moonPhaseImage: UIImageView = {
        $0.image = UIImage(named: "FullMoon")
        return $0
    }(UIImageView())
    
    private lazy var moonPhaseLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var sunImage: UIImageView = {
        $0.image = UIImage(named: "Sun")
        return $0
    }(UIImageView())
    
    private lazy var dayDurationLabel: UILabel = {
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var moonImage: UIImageView = {
        $0.image = UIImage(named: "Moon")
        return $0
    }(UIImageView())
    
    private lazy var nightDurationLabel: UILabel = {
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var verticalDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var firstHorizontalDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var secondHorizontalDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var thirdHorizontalDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var fourthHorizontalDividerView: UIView = {
        $0.backgroundColor = AppColors.sharedInstance.dividerColor
        return $0
    }(UIView())
    
    private lazy var daySunriseLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.textAlignment = .center
        $0.attributedText = NSMutableAttributedString(string: "Восход", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private let sunriseTimeLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var nightMoonRiseLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.textAlignment = .center
        $0.attributedText = NSMutableAttributedString(string: "Восход", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private let moonriseTimeLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var daySunsetLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        $0.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.textAlignment = .center
        $0.attributedText = NSMutableAttributedString(string: "Заход", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private let sunsetTimeLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var nightMoonsetLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.textAlignment = .center
        $0.attributedText = NSMutableAttributedString(string: "Заход", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private let moonsetTimeLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        $0.textAlignment = .center
        return $0
    }(UILabel())


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(sunAndMoonLabel)
        contentView.addSubview(moonPhaseImage)
        contentView.addSubview(moonPhaseLabel)
        contentView.addSubview(sunImage)
        contentView.addSubview(dayDurationLabel)
        contentView.addSubview(moonImage)
        contentView.addSubview(nightDurationLabel)
        contentView.addSubview(verticalDividerView)
        contentView.addSubview(firstHorizontalDividerView)
        contentView.addSubview(secondHorizontalDividerView)
        contentView.addSubview(thirdHorizontalDividerView)
        contentView.addSubview(fourthHorizontalDividerView)
        contentView.addSubview(daySunriseLabel)
        contentView.addSubview(sunriseTimeLabel)
        contentView.addSubview(nightMoonRiseLabel)
        contentView.addSubview(moonriseTimeLabel)
        contentView.addSubview(daySunsetLabel)
        contentView.addSubview(sunsetTimeLabel)
        contentView.addSubview(nightMoonsetLabel)
        contentView.addSubview(moonsetTimeLabel)
        
        sunAndMoonLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
        }
        
        moonPhaseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sunAndMoonLabel)
            make.trailing.equalToSuperview()
        }
        
        moonPhaseImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(moonPhaseLabel)
            make.trailing.equalTo(moonPhaseLabel.snp.leading).offset(-5)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        verticalDividerView.snp.makeConstraints { (make) in
            make.top.equalTo(sunAndMoonLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-7)
            make.height.equalTo(100)
            make.width.equalTo(0.5)
            make.centerX.equalToSuperview()
        }
        
        sunImage.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(19)
            make.centerY.equalTo(dayDurationLabel)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        dayDurationLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(verticalDividerView.snp.leading).offset(-17)
            make.top.equalTo(sunAndMoonLabel.snp.bottom).offset(18)
        }
        
        moonImage.snp.makeConstraints { (make) in
            make.leading.equalTo(verticalDividerView.snp.trailing).offset(29)
            make.centerY.equalTo(sunImage)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        nightDurationLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(moonImage)
        }
        
        firstHorizontalDividerView.snp.makeConstraints { (make) in
            make.top.equalTo(dayDurationLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalTo(verticalDividerView.snp.leading).offset(-12)
            make.height.equalTo(0.5)
        }
        
        secondHorizontalDividerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(firstHorizontalDividerView)
            make.leading.equalTo(verticalDividerView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        daySunriseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstHorizontalDividerView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(18)
        }
        
        sunriseTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(verticalDividerView.snp.leading).offset(-17)
            make.centerY.equalTo(daySunriseLabel)
        }
        
        nightMoonRiseLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(verticalDividerView.snp.trailing).offset(27)
            make.centerY.equalTo(daySunriseLabel)
        }
        
        moonriseTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(daySunriseLabel)
        }
        
        thirdHorizontalDividerView.snp.makeConstraints { (make) in
            make.top.equalTo(sunriseTimeLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(verticalDividerView.snp.leading).offset(-12)
            make.height.equalTo(0.5)
        }
        
        fourthHorizontalDividerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(thirdHorizontalDividerView)
            make.leading.equalTo(verticalDividerView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        daySunsetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdHorizontalDividerView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(18)
        }
        
        sunsetTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(verticalDividerView.snp.leading).offset(-17)
            make.centerY.equalTo(daySunsetLabel)
        }
        
        nightMoonsetLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(verticalDividerView.snp.trailing).offset(27)
            make.centerY.equalTo(daySunsetLabel)
        }
        
        moonsetTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(daySunsetLabel)
        }
        
    }
}

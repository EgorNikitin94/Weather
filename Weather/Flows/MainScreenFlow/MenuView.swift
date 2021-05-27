//
//  MenuView.swift
//  Weather
//
//  Created by Егор Никитин on 27.05.2021.
//

import UIKit

final class MenuView: UIView {
    
    //MARK: - Properties
    
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
        return $0
    }(UIImageView())
    
    private lazy var editLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Редактировать ", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var geolocationImage: UIImageView = {
        $0.image = UIImage(named: "MarkWhite")
        return $0
    }(UIImageView())
    
    private lazy var geolocationLabel: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.979, blue: 0.979, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Cан-Франциско", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
    
    //MARK:- Setup layout
    
    private func setupLayout() {
        self.addSubview(smallWeatherIconImage)
        self.addSubview(weatherLabel)
        self.addSubview(editImage)
        self.addSubview(editLabel)
        self.addSubview(geolocationImage)
        self.addSubview(geolocationLabel)
        
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
    }
}

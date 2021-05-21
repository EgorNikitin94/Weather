//
//  HourlyForecastCollectionViewCell.swift
//  Weather
//
//  Created by Егор Никитин on 11.05.2021.
//

import UIKit

final class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    var configure: (time: String, image: UIImage?, temperature: String)? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.27
            timeLabel.attributedText = NSMutableAttributedString(string: configure?.time ?? "0:00", attributes: [NSAttributedString.Key.kern: 0.24, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            weatherImage.image = configure?.image
            paragraphStyle.lineHeightMultiple = 0.95
            temperatureLabel.attributedText = NSMutableAttributedString(string: configure?.temperature ?? "0º", attributes: [NSAttributedString.Key.kern: 0.32, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
    let shadowLayer = CALayer()
    
    let gradientLayer = CAGradientLayer()
    
    private lazy var timeLabel: UILabel = {
        $0.textColor = UIColor(red: 0.613, green: 0.592, blue: 0.592, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 12)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.27
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "0:00", attributes: [NSAttributedString.Key.kern: 0.24, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var temperatureLabel: UILabel = {
        $0.textColor = UIColor(red: 0.204, green: 0.187, blue: 0.187, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.95
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "0º", attributes: [NSAttributedString.Key.kern: 0.32, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var weatherImage: UIImageView = {
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
    
    func configureSelectedItem() {
        
        let shadowPath0 = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 22)
        
        shadowLayer.shadowPath = shadowPath0.cgPath
        
        shadowLayer.shadowColor = UIColor(red: 0.4, green: 0.546, blue: 0.942, alpha: 0.68).cgColor
        
        shadowLayer.shadowOpacity = 1
        
        shadowLayer.shadowRadius = 45
        
        shadowLayer.shadowOffset = CGSize(width: -5, height: 5)
        
        shadowLayer.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        
        contentView.layer.insertSublayer(shadowLayer, at: 0)
        
        gradientLayer.colors = [
            
            UIColor(red: 0.246, green: 0.398, blue: 0.808, alpha: 0.58).cgColor,
            
            UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor
            
        ]
        
        gradientLayer.locations = [0, 0.73]
        
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        
        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        
        gradientLayer.cornerRadius = 22
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        //contentView.backgroundColor = AppColors.sharedInstance.accentBlue
        timeLabel.textColor = .white
        temperatureLabel.textColor = .white
    }
    
    override func prepareForReuse() {
        timeLabel.textColor = .black
        temperatureLabel.textColor = .black
        gradientLayer.removeFromSuperlayer()
        shadowLayer.removeFromSuperlayer()
        
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
            make.centerX.equalToSuperview().offset(1.5)
        }
    }
}

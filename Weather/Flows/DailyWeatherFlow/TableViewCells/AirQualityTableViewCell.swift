//
//  AirQualityTableViewCell.swift
//  Weather
//
//  Created by Егор Никитин on 21.05.2021.
//

import UIKit

final class AirQualityTableViewCell: UITableViewCell {
    
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        $0.attributedText = NSMutableAttributedString(string: "Качество воздуха", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var airQualityNumberLabel: UILabel = {
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 30)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.01
        $0.attributedText = NSMutableAttributedString(string: "42", attributes: [NSAttributedString.Key.kern: 0.6, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var airQualityLabel: UILabel = {
        $0.layer.backgroundColor = UIColor(red: 0.507, green: 0.792, blue: 0.501, alpha: 1).cgColor
        $0.layer.cornerRadius = 5
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        paragraphStyle.alignment = .center
        $0.attributedText = NSMutableAttributedString(string: "хорошо", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var airQualityDescriptionLabel: UILabel = {
        $0.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        $0.attributedText = NSMutableAttributedString(string: "Качество воздуха считается удовлетворительным и загрязнения воздуха представляются незначительными в пределах нормы", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(airQualityNumberLabel)
        contentView.addSubview(airQualityLabel)
        contentView.addSubview(airQualityDescriptionLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview()
        }
        
        airQualityNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        airQualityLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(airQualityNumberLabel)
            make.leading.equalTo(airQualityNumberLabel.snp.trailing).offset(15)
            make.width.equalTo(95)
            make.height.equalTo(26)
        }
        
        airQualityDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(airQualityNumberLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-23)
        }
        
    }
    
}

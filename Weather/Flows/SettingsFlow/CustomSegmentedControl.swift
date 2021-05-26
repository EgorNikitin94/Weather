//
//  CustomSegmentedControl.swift
//  Weather
//
//  Created by Егор Никитин on 07.05.2021.
//

import UIKit

final class CustomSegmentedControl: UIView {
    
    private let userDefaultsKey: String
    
    private let selectedViewColor: UIColor = AppColors.sharedInstance.accentBlue
    
    private let selectedTextColor: UIColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
    
    private let viewColor: UIColor = UIColor(red: 0.996, green: 0.929, blue: 0.914, alpha: 1)
    
    private let textColor: UIColor = UIColor(red: 0.153, green: 0.153, blue: 0.133, alpha: 1)
    
    private lazy var leftView: UIView = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapLeftSide))
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIView())
    
    private lazy var rightView: UIView = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRightSide))
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIView())
    
    private lazy var leftLabel: UILabel = {
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        return $0
    }(UILabel())
    
    private lazy var rightLabel: UILabel = {
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        return $0
    }(UILabel())
    
    init(leftSideText: String, rightSideText: String, userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        leftLabel.attributedText = NSMutableAttributedString(string: leftSideText, attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        rightLabel.attributedText = NSMutableAttributedString(string: rightSideText, attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        leftView.backgroundColor = UserDefaults.standard.bool(forKey: userDefaultsKey) ? selectedViewColor : viewColor
        rightView.backgroundColor = UserDefaults.standard.bool(forKey: userDefaultsKey) ? viewColor : selectedViewColor
        leftLabel.textColor = UserDefaults.standard.bool(forKey: userDefaultsKey) ? selectedTextColor : textColor
        rightLabel.textColor = UserDefaults.standard.bool(forKey: userDefaultsKey) ? textColor : selectedTextColor
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapLeftSide() {
        if UserDefaults.standard.bool(forKey: userDefaultsKey) {
            // Nothing happens
        } else {
            UserDefaults.standard.setValue(true, forKey: userDefaultsKey)
            leftView.backgroundColor = selectedViewColor
            rightView.backgroundColor = viewColor
            leftLabel.textColor = selectedTextColor
            rightLabel.textColor = textColor
        }
        
    }
    
    @objc private func tapRightSide() {
        if UserDefaults.standard.bool(forKey: userDefaultsKey) {
            UserDefaults.standard.setValue(false, forKey: userDefaultsKey)
            leftView.backgroundColor = viewColor
            rightView.backgroundColor = selectedViewColor
            leftLabel.textColor = textColor
            rightLabel.textColor = selectedTextColor
        } else {
            // Nothing happens
        }
    }
    
    private func setupLayout() {
        self.addSubview(leftView)
        self.addSubview(rightView)
        leftView.addSubview(leftLabel)
        rightView.addSubview(rightLabel)
        
        leftView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(40)
        }
        
        rightView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(40)
            make.trailing.equalToSuperview()
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}

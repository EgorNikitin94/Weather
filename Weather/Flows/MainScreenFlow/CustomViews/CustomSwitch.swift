//
//  CustomSwitch.swift
//  Weather
//
//  Created by Егор Никитин on 28.05.2021.
//

import UIKit

final class CustomSwitch: UIView {
    
    //MARK: - Properties
    
    @IBInspectable var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.2) {
                    self.circle.frame.origin.x = 27
                    UserDefaults.standard.setValue(true, forKey: self.userDefaultsKey)
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.circle.frame.origin.x = 0
                    UserDefaults.standard.setValue(false, forKey: self.userDefaultsKey)
                }
            }
        }
    }
    
    private let userDefaultsKey: String
    
    private lazy var circle: UIView = {
        $0.backgroundColor = UIColor(red: 1, green: 0.988, blue: 0.988, alpha: 1)
        $0.layer.borderColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor
        return $0
    }(UIView())
    
    private lazy var body: UIView = {
        $0.backgroundColor = UIColor(red: 0.421, green: 0.405, blue: 0.405, alpha: 1)
        return $0
    }(UIView())
    
    //MARK: - Init
    
    init(isSelected: Bool, userDefaultsKey: String) {
        self.isSelected = isSelected
        self.userDefaultsKey = userDefaultsKey
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        self.addSubview(body)
        self.addSubview(circle)
        circle.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        body.frame = CGRect(x: 6, y: 1, width: 30, height: 13)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchTapped))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout settings
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circle.layer.borderWidth = 0.3
        circle.layer.cornerRadius = circle.frame.height / 2
        body.layer.cornerRadius = 7
    }
    //MARK: - Actions
    
    @objc private func switchTapped() {
        isSelected.toggle()
    }
    
}

//
//  ViewController.swift
//  Weather
//
//  Created by Егор Никитин on 03.05.2021.
//

import UIKit
import SnapKit

final class GeolocationAskViewController: UIViewController {

    private lazy var womanWithUmbrellaImageView: UIImageView = {
        $0.image = UIImage(named: "WomanUmbrella")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = UIColor(red: 0.973, green: 0.961, blue: 0.961, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        $0.attributedText = NSMutableAttributedString(string: "Разрешить приложению  Weather использовать данные \nо местоположении вашего устройства ", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        // Line height: 20 pt
        $0.attributedText = NSMutableAttributedString(string: "Чтобы получить более точные прогнозы погоды во время движения или путешествия", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var changeSelectionLabel: UILabel = {
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 14)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        // Line height: 20 pt
        $0.attributedText = NSMutableAttributedString(string: "Вы можете изменить свой выбор в любое время из меню приложения", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    private lazy var useMyGeolocationButton: UIButton = {
        $0.layer.backgroundColor = AppColors.shared.orange
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        let title = NSMutableAttributedString(string: "ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ  УСТРОЙСТВА", attributes: [NSAttributedString.Key.kern: -0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont(name: "Rubik-Regular", size: 12) as Any, NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        $0.setAttributedTitle(title, for: .normal)
        $0.layer.cornerRadius = 10
        return $0
    }(UIButton())
    
    private lazy var doNotUseMyGeolocationButton: UILabel = {
        $0.textColor = UIColor(red: 0.992, green: 0.986, blue: 0.963, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        // Line height: 21 pt
        // (identical to box height)
        $0.textAlignment = .right
        $0.attributedText = NSMutableAttributedString(string: "НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return $0
    }(UILabel())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        
        view.addSubview(womanWithUmbrellaImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(changeSelectionLabel)
        view.addSubview(useMyGeolocationButton)
        view.addSubview(doNotUseMyGeolocationButton)

        womanWithUmbrellaImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(62)
            make.leading.equalToSuperview().offset(35.5)
            make.trailing.equalToSuperview().offset(-35)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(womanWithUmbrellaImageView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-34)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-42)
        }
        
        changeSelectionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-34)
        }

        useMyGeolocationButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-17)
            make.height.equalTo(40)
        }

        doNotUseMyGeolocationButton.snp.makeConstraints { (make) in
            make.top.equalTo(useMyGeolocationButton.snp.bottom).offset(25)
            make.trailing.equalToSuperview().offset(-17)
            make.bottom.equalToSuperview().offset(-77)
        }
        
    }

}


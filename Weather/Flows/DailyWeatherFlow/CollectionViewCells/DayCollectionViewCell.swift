//
//  DayCollectionViewCell.swift
//  Weather
//
//  Created by Егор Никитин on 19.05.2021.
//

import UIKit

final class DayCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Configure
    
    var configure: String? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.03
            dateLabel.attributedText = NSMutableAttributedString(string: configure ?? "", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
   //MARK: - Properties
    
    override var isSelected: Bool {
        willSet(newValue) {
            if newValue {
                UIView.animate(withDuration: 0.3) {
                    self.contentView.backgroundColor = AppColors.sharedInstance.accentBlue
                    self.dateLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                }
            } else {
                contentView.backgroundColor = .white
                dateLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
            }
        }
    }
    
    private lazy var dateLabel: UILabel = {
        $0.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        $0.font = UIFont(name: "Rubik-Regular", size: 18)
        return $0
    }(UILabel())
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellView()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup layout
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    
    private func setupCellView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
    }
    
    private func setupLayout() {
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

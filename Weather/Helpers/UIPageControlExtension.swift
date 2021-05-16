//
//  UIPageControlExtension.swift
//  Weather
//
//  Created by Егор Никитин on 14.05.2021.
//

import UIKit

extension UIPageControl {

    func customPageControl(dotFillColor: UIColor, dotBorderColor: UIColor, dotBorderWidth: CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            print(dotView)
            dotView.backgroundColor = currentPage == pageIndex ? dotFillColor : .clear
            dotView.layer.cornerRadius = dotView.frame.size.height / 2
            dotView.layer.borderColor = dotBorderColor.cgColor
            dotView.layer.borderWidth = dotBorderWidth
        }
    }

}

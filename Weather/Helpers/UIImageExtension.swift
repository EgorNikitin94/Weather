//
//  UIImageExtension.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

extension UIImage {

    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

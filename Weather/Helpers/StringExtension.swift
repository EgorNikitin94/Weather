//
//  StringExtension.swift
//  Weather
//
//  Created by Егор Никитин on 12.05.2021.
//

import Foundation

extension String {
    func uppercasedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func uppercasedFirstLetter() {
        self = self.uppercasedFirstLetter()
    }
}

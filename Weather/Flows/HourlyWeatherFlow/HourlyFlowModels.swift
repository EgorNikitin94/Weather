//
//  FlowModels.swift
//  Weather
//
//  Created by Егор Никитин on 22.05.2021.
//

import UIKit

struct HourlyWeather {
    let date: NSMutableAttributedString
    let time: NSMutableAttributedString
    let temperature: NSMutableAttributedString
    let weatherImage: UIImage?
    let weatherDescription: NSMutableAttributedString
    let windSpeed: NSMutableAttributedString
    let precipitation: NSMutableAttributedString
    let cloudiness: NSMutableAttributedString
}

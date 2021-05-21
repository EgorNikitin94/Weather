//
//  FlowModels.swift
//  Weather
//
//  Created by Егор Никитин on 20.05.2021.
//

import UIKit

enum PartOfDay: String {
    case day = "День"
    case night = "Ночь"
}

struct Day {
    let dayPart: NSMutableAttributedString
    let weatherImage: UIImage?
    let temperature: NSMutableAttributedString
    let temperatureDescription: NSMutableAttributedString
    let thermometerImage: UIImage?
    let feelsTemperature: NSMutableAttributedString
    let windSpeed: NSMutableAttributedString
    let uv: NSMutableAttributedString
    let precipitation:NSMutableAttributedString
    let cloudiness: NSMutableAttributedString
}

struct SunAndMoonPhase {
    let moonPhase: NSMutableAttributedString
    let dayDuration: NSMutableAttributedString
    let nightDuration: NSMutableAttributedString
    let sunriseTime: NSMutableAttributedString
    let sunsetTime: NSMutableAttributedString
    let moonriseTime: NSMutableAttributedString
    let moonsetTime: NSMutableAttributedString
}

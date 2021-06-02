//
//  Weather.swift
//  Weather
//
//  Created by Егор Никитин on 01.06.2021.
//

import WidgetKit
import Foundation

struct WeatherWidgetData: TimelineEntry, Codable {

    var date: Date
    let currentWeatherTemperature: Int
    let currentWeatherDescription: String
    let cityName: String
    let mainWeather: String
    let dailyWeather: [DailyWeatherWidget]
    
    func reloadWidget() {
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            // Fallback on earlier versions
        }
    }
    
}

struct DailyWeatherWidget: Codable, Identifiable {
    var id = UUID()
    let date: String
    let precipitation: Int
    let weatherMain: String
    let minTemperature: Int
    let maxTemperature: Int
}

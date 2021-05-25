//
//  Weather.swift
//  Weather
//
//  Created by Егор Никитин on 11.05.2021.
//

import Foundation

struct WeatherData: Decodable {
    var city: City?
    let current: Hourly
    let timezoneOffset: Int
    let moscowTimeOffset: Int = 10800
    var hourly: [Hourly]
    var daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case current, hourly, daily, city
        case timezoneOffset = "timezone_offset"
    }
}

struct Hourly: Decodable {
    let dt, humidity: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let windSpeed, uvi: Double
    let clouds, windDeg: Int
    let weather: [Weather]
    let pop: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case uvi, clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, humidity
        case pop
    }
}

struct Weather: Decodable {
    let main: String
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
    }
}

struct Daily: Decodable {
    let dt, sunrise, sunset: Int
    let moonrise, moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let humidity: Int
    let pop, windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let clouds: Int
    let rain: Double?
    let uvi: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case humidity
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, pop, rain, uvi
    }
}

struct FeelsLike: Decodable {
    let day, night, eve, morn: Double
}

struct Temp: Decodable {
    let day, min, max, night: Double
}

//
//  Weather.swift
//  Weather
//
//  Created by Егор Никитин on 11.05.2021.
//

import Foundation

struct WeatherData: Decodable {
    var city: City?
    let current: Current
    let timezone: String
    let timezoneOffset: Int
    let moscowTimeOffset: Int = 10800
    var hourly: [Hourly]
    var daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case current,timezone, hourly, daily, city
        case timezoneOffset = "timezone_offset"
    }
}

struct Current: Decodable {
    let dt: Int
    let sunrise, sunset: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

struct Hourly: Decodable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let rain: Rain?
    let windGust, pop: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain
        case windGust = "wind_gust"
        case pop
    }
}

struct Weather: Decodable {
    let id: Int?
    let main: String
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
    }
}

struct Rain: Decodable {
    let h1: Double

    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
    }
}

struct Daily: Decodable {
    let dt, sunrise, sunset: Int
    let moonrise, moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }
}

struct FeelsLike: Decodable {
    let day, night, eve, morn: Double
}

struct Temp: Decodable {
    let min: Double
    let max: Double
}

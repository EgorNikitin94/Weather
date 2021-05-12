//
//  WeatherMainViewModel.swift
//  Weather
//
//  Created by Егор Никитин on 11.05.2021.
//

import UIKit

final class WeatherMainViewModel: WeatherMainViewControllerOutput {
    
    var onDataLoaded: (()->Void)?
    
    private var weatherDataStorage: WeatherData? {
        didSet {
            onDataLoaded?()
        }
    }
    
    init() {
        loadWeatherData()
    }
    
    public func configureMainInformationView() -> (dailyTemperature: String, currentTemperature: String, descriptionWeather: String, cloudy: String, windSpeed: String, humidity: String, sunrise: String, sunset: String, currentDate: String)? {
        guard let object = weatherDataStorage else {
            return nil
        }
        let minTempStr = String(format: "%.0f", object.daily.first?.temp.min ?? 0)
        let maxTempStr = String(format: "%.0f", object.daily.first?.temp.max ?? 0)
        let currentTempStr = String(format: "%.0f", object.current.temp)
        let windSpeedStr = String(format: "%.0f", object.current.windSpeed)
        let dailyTemperature = minTempStr + "º /" + maxTempStr + "º"
        let currentTemperature = currentTempStr + "º"
        let descriptionWeather = object.current.weather.first?.weatherDescription ?? "".uppercasedFirstLetter()
        let cloudy = "\(object.current.clouds)"
        let windSpeed = windSpeedStr + "м/с"
        let humidity = "\(object.current.humidity)%"
        let localData = TimeInterval(object.timezoneOffset - object.moscowTimeOffset)
        let sunriseDate = NSDate(timeIntervalSince1970: TimeInterval(object.current.sunrise) + localData)
        let sunsetDate = NSDate(timeIntervalSince1970: TimeInterval(object.current.sunset) + localData)
        let sunFormatter = DateFormatter()
        sunFormatter.dateFormat = "HH:mm"
        let sunrise = sunFormatter.string(from: sunriseDate as Date)
        let sunset = sunFormatter.string(from: sunsetDate as Date)
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.current.dt) + localData)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, E d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        let currentDate = formatter.string(from: date as Date)
        
        return (dailyTemperature, currentTemperature, descriptionWeather, cloudy, windSpeed, humidity, sunrise, sunset, currentDate)
        
    }
    
    public func configureHourlyItem(with object: Hourly) -> (time: String, image: UIImage?, temperature: String)? {
        guard let weather = weatherDataStorage else {
            return nil
        }
        let hourlyTempStr = String(format: "%.0f", object.temp)
        let temperature = hourlyTempStr + "º"
        let localData = TimeInterval(weather.timezoneOffset - weather.moscowTimeOffset)
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.dt) + localData)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: date as Date)
        let image = setupWeatherImage(weather: object.weather.first?.main)
        return (time, image, temperature)
    }
    
    public func configureDailyItem(with object: Daily) -> (dayDate: String, image: UIImage?, humidity: String, descriptionWeather: String, temperature: String)? {
        guard let weather = weatherDataStorage else {
            return nil
        }
        let localData = TimeInterval(weather.timezoneOffset - weather.moscowTimeOffset)
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.dt) + localData)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        let dayDate = formatter.string(from: date as Date)
        let image = setupWeatherImage(weather: object.weather.first?.main)
        let humidity = "\(object.humidity)%"
        let descriptionWeather = "\(object.weather.first?.weatherDescription ?? "")".uppercasedFirstLetter()
        let minTempStr = String(format: "%.0f", object.temp.min)
        let maxTempStr = String(format: "%.0f", object.temp.max)
        let temperature = minTempStr + "º-" + maxTempStr + "º"
        
        return (dayDate, image, humidity, descriptionWeather, temperature)
    }
    
    public func getHourlyWeatherArray() -> [Hourly] {
        guard let weather = weatherDataStorage else {
            return []
        }
        var wetherArray = [Hourly]()
        for (index, hourlyWeather) in weather.hourly.enumerated() {
            switch index {
            case 0:
                wetherArray.append(hourlyWeather)
            case 3:
                wetherArray.append(hourlyWeather)
            case 6:
                wetherArray.append(hourlyWeather)
            case 9:
                wetherArray.append(hourlyWeather)
            case 12:
                wetherArray.append(hourlyWeather)
            case 15:
                wetherArray.append(hourlyWeather)
            case 18:
                wetherArray.append(hourlyWeather)
            case 21:
                wetherArray.append(hourlyWeather)
            default:
                break
            }
        }
        return wetherArray
    }
    
    public func getDailyWeatherArray() -> [Daily] {
        guard let weather = weatherDataStorage else {
            return []
        }
        var wetherArray = weather.daily
        wetherArray.removeFirst()
        
        return wetherArray
    }
    
    private func setupWeatherImage(weather: String?) -> UIImage? {
        switch weather {
        case "Clear":
            return UIImage(named: "Sun")
        case "Rain":
            return UIImage(named: "CloudRain")
        case "Clouds":
            return UIImage(named: "Cloud")
        case "Fog":
            return UIImage(named: "Cloud")
        default:
            return UIImage(named: "Cloud")
        }
    }
    
    private func loadWeatherData() {
        LocationManager.sharedInstance.getCurrentLocation { (locationCoordinate) in
            NetworkService.getWeatherData(locationCoordinate: locationCoordinate) { [weak self] (weatherData) in
                self?.weatherDataStorage = weatherData
            }
        }
    }
    
}

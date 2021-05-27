//
//  HourlyWeatherViewModel.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

protocol HourlyWeatherViewModelOutput {
    func getTimezoneOffset() -> (timezoneOffset: Int, moscowTimeOffset: Int)
    func configureCityName() -> NSMutableAttributedString?
    func getHourlyWeatherArray() -> [CachedHourly]
    func configureHourlyCell(with object: CachedHourly) -> HourlyWeather?
}

final class HourlyWeatherViewModel: HourlyWeatherViewModelOutput {
    
    //MARK: - Properties
        
    private let cachedWeather: CachedWeather?
    
    //MARK: - Init
    
    init(cachedWeather: CachedWeather?) {
        self.cachedWeather = cachedWeather
    }
    
    //MARK: - Configure methods
    
    public func getTimezoneOffset() -> (timezoneOffset: Int, moscowTimeOffset: Int) {
        guard let timezoneOffset = cachedWeather?.timezoneOffset, let moscowTimeOffset = cachedWeather?.moscowTimeOffset else {
            return (timezoneOffset: 0, moscowTimeOffset: 0)
        }
        
        return (timezoneOffset: timezoneOffset, moscowTimeOffset: moscowTimeOffset)
        
    }
    
    
    public func configureCityName() -> NSMutableAttributedString? {
        guard let city = cachedWeather?.city else {
            return nil
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        return NSMutableAttributedString(string: city.fullName, attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    public func getHourlyWeatherArray() -> [CachedHourly] {
        guard let weather = cachedWeather else {
            return []
        }
        var wetherArray = [CachedHourly]()
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
    
    public func configureHourlyCell(with object: CachedHourly) -> HourlyWeather? {
        guard let weather = cachedWeather else {
            return nil
        }
        
        let localData = TimeInterval(weather.timezoneOffset - weather.moscowTimeOffset)
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.dt) + localData)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineHeightMultiple = 1.03
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ru_RU")
        dayFormatter.dateFormat = "E dd/MM"
        let dayDate = NSMutableAttributedString(string: dayFormatter.string(from: date as Date).lowercased(), attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let timeInterval = NSDate(timeIntervalSince1970: TimeInterval(object.dt) + localData)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh:mm a" : "HH:mm"
        paragraphStyle.lineHeightMultiple = 1.15
        let time = NSMutableAttributedString(string: timeFormatter.string(from: timeInterval as Date), attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let temperatureValueString = String(format: "%.0f", convertTemperature(object.temp))
        paragraphStyle.lineHeightMultiple = 1.03
        let temperature = NSMutableAttributedString(string: temperatureValueString + "º", attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let weatherImage = setupWeatherImage(weather: object.weathers.first?.main)
        
        paragraphStyle.lineHeightMultiple = 1.15
        let feelsTemperature = String(format: "%.0f", convertTemperature(object.feelsLike))
        let weatherDescriptionString = "\(object.weathers.first?.weatherDescription.uppercasedFirstLetter() ?? "") По ощущению \(feelsTemperature)º"
        let weatherDescription = NSMutableAttributedString(string: weatherDescriptionString, attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let windSpeed = convertSpeed(speed: object.windSpeed)
        let windDirection = Double(object.windDeg).direction
        let windSpeedfull = NSMutableAttributedString(string: "\(windSpeed) \(windDirection)", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let precipitationValue = (object.pop) * 100
        let precipitationValueString = String(format: "%.0f", precipitationValue)
        let precipitation = NSMutableAttributedString(string: precipitationValueString + "%", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let cloudiness = NSMutableAttributedString(string: "\(object.clouds)%", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        return HourlyWeather(date: dayDate,
                             time: time,
                             temperature: temperature,
                             weatherImage: weatherImage,
                             weatherDescription: weatherDescription,
                             windSpeed: windSpeedfull,
                             precipitation: precipitation,
                             cloudiness: cloudiness)
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
    
    private func convertTemperature(_ temperature: Double) -> Double {
        if UserDefaults.standard.bool(forKey:UserDefaultsKeys.isCelsiusChosenBoolKey.rawValue) {
            return temperature
        } else {
            //°F
            return (9.0/5.0) * temperature + 32.0
        }
    }
    
    private func convertSpeed(speed: Double) -> String {
        if UserDefaults.standard.bool(forKey:UserDefaultsKeys.isMiChosenBoolKey.rawValue) {
            //miles per hour
            let windSpeedStr = String(format: "%.1f", speed * 0.44704)
            return windSpeedStr + "миль\\ч"
        } else {
            let windSpeedStr = String(format: "%.0f", speed)
            return windSpeedStr + "м\\с"
        }
    }
    
}


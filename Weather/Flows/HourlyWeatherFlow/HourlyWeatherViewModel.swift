//
//  HourlyWeatherViewModel.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

protocol HourlyWeatherViewModelOutput {
    func configureCityName() -> NSMutableAttributedString?
    func getHourlyWeatherArray() -> [Hourly]
    func configureHourlyCell(with object: Hourly) -> HourlyWeather?
}

final class HourlyWeatherViewModel: HourlyWeatherViewModelOutput {
    
    var weatherData: WeatherData?
    
    init(weatherData: WeatherData?) {
        self.weatherData = weatherData
    }
    
    
    public func configureCityName() -> NSMutableAttributedString? {
        guard let city = weatherData?.city else {
            return nil
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        return NSMutableAttributedString(string: city.fullName, attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    public func getHourlyWeatherArray() -> [Hourly] {
        guard let weather = weatherData else {
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
    
    public func configureHourlyCell(with object: Hourly) -> HourlyWeather? {
        
        guard let weather = weatherData else {
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
        
        let weatherImage = setupWeatherImage(weather: object.weather.first?.main)
        
        paragraphStyle.lineHeightMultiple = 1.15
        let feelsTemperature = String(format: "%.0f", convertTemperature(object.feelsLike))
        let weatherDescriptionString = "\(object.weather.first?.weatherDescription.uppercasedFirstLetter() ?? "") По ощущению \(feelsTemperature)º"
        let weatherDescription = NSMutableAttributedString(string: weatherDescriptionString, attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let windSpeed = convertSpeed(speed: object.windSpeed)
        let windDirection = Double(object.windDeg).direction
        let windSpeedfull = NSMutableAttributedString(string: "\(windSpeed) \(windDirection)", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let precipitationValueString = String(format: "%.0f", object.pop  ?? "0")
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


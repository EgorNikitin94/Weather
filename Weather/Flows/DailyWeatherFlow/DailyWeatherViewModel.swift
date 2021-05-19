//
//  DailyWeatherViewModel.swift
//  Weather
//
//  Created by Егор Никитин on 18.05.2021.
//

import UIKit

protocol DailyWeatherViewModelOutput {
    func getDailyWeatherArray() -> [Daily]
    func configureDayItem(with object: Daily) -> String?
    func configurePartOfDayCell(with object: Daily, partOfDay: PartOfDay) -> Day?
}

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


final class DailyWeatherViewModel: DailyWeatherViewModelOutput {
    
    private let weatherData: WeatherData?
    
    init(weatherData: WeatherData?) {
        self.weatherData = weatherData
    }
    
    func getDailyWeatherArray() -> [Daily] {
        guard let weather = weatherData else {
            return []
        }
        
        return weather.daily
    }
    
    func configureDayItem(with object: Daily) -> String? {
        
        guard let weather = weatherData else {
            return nil
        }
        let localData = TimeInterval(weather.timezoneOffset - weather.moscowTimeOffset)
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.dt) + localData)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM E"
        let dayDate = formatter.string(from: date as Date).uppercased()
        
        return dayDate
    }
    
    func configurePartOfDayCell(with object: Daily, partOfDay: PartOfDay) -> Day? {
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineHeightMultiple = 1.03
        
        let dayPart = NSMutableAttributedString(string: partOfDay.rawValue, attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        if partOfDay == .day {
            let weatherImage = setupWeatherImage(weather: object.weather.first?.main)
            
            let temperatureValueString = String(format: "%.0f", convertTemperature(object.temp.day))
            paragraphStyle.lineHeightMultiple = 1.01
            let temperature = NSMutableAttributedString(string: temperatureValueString + "º", attributes: [NSAttributedString.Key.kern: 0.6, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            paragraphStyle.lineHeightMultiple = 1.03
            let temperatureDescription = NSMutableAttributedString(string: "\(object.weather.first?.weatherDescription ?? "")".uppercasedFirstLetter(), attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let thermometerImage = setThermometerImage(temp: object.feelsLike.day)
            
            paragraphStyle.lineHeightMultiple = 1.03
            let feelsTemperatureValueString = String(format: "%.0f", convertTemperature(object.feelsLike.day))
            let feelsTemperature = NSMutableAttributedString(string: feelsTemperatureValueString + "º", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let windSpeedValueString = String(format: "%.0f", convertTemperature(object.windSpeed))
            let windDirection = Double(object.windDeg).direction
            let windSpeed = NSMutableAttributedString(string: "\(windSpeedValueString)\(windDirection)", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let uvValueString = String(format: "%.0f", convertTemperature(object.uvi))
            let uvDescriptionString = setupUvDescription(uv: object.uvi)
            let uv = NSMutableAttributedString(string: uvValueString + uvDescriptionString, attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let precipitationValueString = String(format: "%.0f", object.pop)
            let precipitation = NSMutableAttributedString(string: precipitationValueString + "%", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let cloudiness = NSMutableAttributedString(string: "\(object.clouds)%", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            return Day(dayPart: dayPart,
                       weatherImage: weatherImage,
                       temperature: temperature,
                       temperatureDescription: temperatureDescription,
                       thermometerImage: thermometerImage,
                       feelsTemperature: feelsTemperature,
                       windSpeed: windSpeed,
                       uv: uv, precipitation:
                        precipitation,
                       cloudiness: cloudiness)
        } else {
            let weatherImage = setupWeatherImage(weather: object.weather.first?.main)
            
            let temperatureValueString = String(format: "%.0f", convertTemperature(object.temp.night))
            paragraphStyle.lineHeightMultiple = 1.01
            let temperature = NSMutableAttributedString(string: temperatureValueString + "º", attributes: [NSAttributedString.Key.kern: 0.6, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            paragraphStyle.lineHeightMultiple = 1.03
            let temperatureDescription = NSMutableAttributedString(string: "\(object.weather.first?.weatherDescription ?? "")".uppercasedFirstLetter(), attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let thermometerImage = setThermometerImage(temp: object.feelsLike.night)
            
            paragraphStyle.lineHeightMultiple = 1.03
            let feelsTemperatureValueString = String(format: "%.0f", convertTemperature(object.feelsLike.night))
            let feelsTemperature = NSMutableAttributedString(string: feelsTemperatureValueString + "º", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let windSpeedValueString = String(format: "%.0f", convertTemperature(object.windSpeed))
            let windDirection = Double(object.windDeg).direction
            let windSpeed = NSMutableAttributedString(string: "\(windSpeedValueString)\(windDirection)", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let uvValueString = String(format: "%.0f", convertTemperature(object.uvi))
            let uvDescriptionString = setupUvDescription(uv: object.uvi)
            let uv = NSMutableAttributedString(string: uvValueString + uvDescriptionString, attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let precipitationValueString = String(format: "%.0f", object.pop)
            let precipitation = NSMutableAttributedString(string: precipitationValueString + "%", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            let cloudiness = NSMutableAttributedString(string: "\(object.clouds)%", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            return Day(dayPart: dayPart,
                       weatherImage: weatherImage,
                       temperature: temperature,
                       temperatureDescription: temperatureDescription,
                       thermometerImage: thermometerImage,
                       feelsTemperature: feelsTemperature,
                       windSpeed: windSpeed,
                       uv: uv, precipitation:
                        precipitation,
                       cloudiness: cloudiness)
        }
        
    }
    
    private func setThermometerImage(temp: Double) -> UIImage? {
        if temp < 0 {
            return UIImage(named: "ThermometerCold")
        } else {
            return UIImage(named: "Thermometer")
        }
    }
    
    private func setupUvDescription(uv: Double) -> String {
        switch uv {
        case ..<3:
            return "(низкий)"
        case 3..<6:
            return "(умерен.)"
        case 6..<8:
            return "(высокий)"
        case 8...:
            return "(оч. высокий)"
        default:
            return ""
        }
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
            return windSpeedStr + "mile\\h"
        } else {
            let windSpeedStr = String(format: "%.0f", speed)
            return windSpeedStr + "m\\s"
        }
    }
    
    
}

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
    func configureSunAndMoonCell(with object: Daily) -> SunAndMoonPhase?
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
        formatter.locale = Locale(identifier: "ru_RU")
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
            
            let windSpeedValueString = convertSpeed(speed: object.windSpeed)
            let windDirection = Double(object.windDeg).direction
            let windSpeed = NSMutableAttributedString(string: "\(windSpeedValueString) \(windDirection)", attributes: [NSAttributedString.Key.kern: -0.18, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
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
            
            let windSpeedValueString = convertSpeed(speed: object.windSpeed)
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
    
    func configureSunAndMoonCell(with object: Daily) -> SunAndMoonPhase? {
        
        let moonPhase = getAttributedStringMoonPhase(moonPhase: object.moonPhase)
        guard let dayDuration = getAttributedStringTime(time: object.sunset - object.sunrise, isLongTime: true) else {return nil}
        guard let nightDuration = getAttributedStringTime(time: object.moonset - object.moonrise, isLongTime: true) else {return nil}
        guard let sunriseTime = getAttributedStringTime(time: object.sunrise, isLongTime: false) else {return nil}
        guard let sunsetTime = getAttributedStringTime(time: object.sunset, isLongTime: false) else {return nil}
        guard let moonriseTime = getAttributedStringTime(time: object.moonrise, isLongTime: false) else {return nil}
        guard let moonsetTime = getAttributedStringTime(time: object.moonset, isLongTime: false) else {return nil}
        
        return SunAndMoonPhase(moonPhase: moonPhase,
                               dayDuration: dayDuration,
                               nightDuration: nightDuration,
                               sunriseTime: sunriseTime,
                               sunsetTime: sunsetTime,
                               moonriseTime: moonriseTime,
                               moonsetTime: moonsetTime)
    }
    
    private func getAttributedStringMoonPhase(moonPhase: Double) -> NSMutableAttributedString {
        
        var text = ""
        
        switch moonPhase {
        case 0, 1:
            text = "Новолуние"
        case 0..<0.25:
            text = "Молодая луна"
        case 0.25:
            text = "Первая четверть луны"
        case 0.25..<0.5:
            text = "Прибывающая луна"
        case 0.5:
            text = "Полнолуние"
        case 0.5..<0.75:
            text = "Убывающая луна"
        case 0.75:
            text = "Последняя четверть луны"
        case 0.75..<1:
            text = "Старая луна"
        default:
            text = ""
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineHeightMultiple = 1.15
        
        return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
    }
    
    private func getAttributedStringTime(time: Int, isLongTime: Bool) -> NSMutableAttributedString? {
        
        guard let weatherData = weatherData else { return nil}
        
        let localData = TimeInterval(weatherData.timezoneOffset - weatherData.moscowTimeOffset)
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(time) + localData)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineHeightMultiple = 1.05
        
        if isLongTime {
            let hourFormatter = DateFormatter()
            let minuteFormatter = DateFormatter()
            let amPmFormatter = DateFormatter()
            hourFormatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh" : "HH"
            minuteFormatter.dateFormat = "mm"
            amPmFormatter.dateFormat = "a"
            let stringDateHour = hourFormatter.string(from: date as Date)
            let stringDateMinute = minuteFormatter.string(from: date as Date)
            let stringDateAmPm = amPmFormatter.string(from: date as Date)
            
            guard UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) else {
                let fullString = stringDateHour + "ч " + stringDateMinute + " мин"
                return NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            }
            
            let fullString = stringDateHour + "ч " + stringDateMinute + " мин " + stringDateAmPm
            return NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
        } else {
            let shortFormatter = DateFormatter()
            shortFormatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh:mm a" : "HH:mm"
            let stringDate = shortFormatter.string(from: date as Date)
            return NSMutableAttributedString(string: stringDate, attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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

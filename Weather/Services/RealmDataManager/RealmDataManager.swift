//
//  RealmDataManager.swift
//  Weather
//
//  Created by Егор Никитин on 24.05.2021.
//

import Foundation
import RealmSwift

final class RealmDataManager {
    
    static let sharedInstance: RealmDataManager = RealmDataManager()
    
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("weather.realm")
        return try? Realm(configuration: config)
    }
    
    private init() {
        
    }
    
    func getCachedWeather() -> [CachedWeather] {
        let notCurrentLocationWeatherPredicate = NSPredicate(format: "isCurrentLocationWeather == false")
        guard let objects = realm?.objects(CachedWeather.self).filter(notCurrentLocationWeatherPredicate) else {
            return []
        }
        return Array(objects)
    }
    
    func getCurrentLocationCachedWeather() -> CachedWeather? {
        return realm?.objects(CachedWeather.self).first(where: {$0.isCurrentLocationWeather == true})
    }
    
    func isRealmContainsCurrentLocationCachedWeather() -> Bool {
        let currentLocationCachedWeather = realm?.objects(CachedWeather.self).first(where: {$0.isCurrentLocationWeather == true})
        if currentLocationCachedWeather != nil {
            return true
        } else {
            return false
        }
    }
    
    func deleteCurrentLocationCachedWeather() {
        guard let cachedWeather = realm?.objects(CachedWeather.self).first(where: {$0.isCurrentLocationWeather == true}) else {return}
        
        try? realm?.write {
    
            for hourlyWeather in cachedWeather.hourly {
                realm?.delete(hourlyWeather.weathers)
            }
            
            for dailyWeather in cachedWeather.daily {
                realm?.delete(dailyWeather.weathers)
                
                if dailyWeather.feelsLike != nil {
                    realm?.delete(dailyWeather.feelsLike!)
                }
                
                if dailyWeather.temp != nil {
                    realm?.delete(dailyWeather.temp!)
                }
            }
            
            if cachedWeather.city?.location != nil {
                realm?.delete(cachedWeather.city!.location!)
            }
            
            if cachedWeather.city != nil {
                realm?.delete(cachedWeather.city!)
            }
            
            if cachedWeather.current != nil {
                realm?.delete(cachedWeather.current!)
            }
            
            realm?.delete(cachedWeather.daily)
            realm?.delete(cachedWeather.hourly)
            realm?.delete(cachedWeather)
        }
    }
    
    func addCachedWeather(_ weather: WeatherData, isCurrentLocation: Bool = false) {
        guard let city = weather.city else {
            return
        }
        let cachedCity = getCachedCity(city)
        let cashedCurrent = getCachedCurrent(weather)
        let cashHourly = getCachedHourly(weather.hourly)
        let cachedDaily = getCachedDaily(weather.daily)
        let cachedWeather = CachedWeather(city: cachedCity, current: cashedCurrent, timezoneOffset: weather.timezoneOffset, hourly: cashHourly, daily: cachedDaily)
        
        if isCurrentLocation {
            cachedWeather.isCurrentLocationWeather = true
        }
        
        do {
            try realm?.write {
                realm?.add(cachedWeather)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func getNewCachedWeather(_ weather: WeatherData) -> CachedWeather? {
        guard let city = weather.city else {
            return nil
        }
        let cachedCity = getCachedCity(city)
        let cashedCurrent = getCachedCurrent(weather)
        let cashHourly = getCachedHourly(weather.hourly)
        let cachedDaily = getCachedDaily(weather.daily)
        return CachedWeather(city: cachedCity, current: cashedCurrent, timezoneOffset: weather.timezoneOffset, hourly: cashHourly, daily: cachedDaily)
    }
    
    func updateCachedWeather(_ weather: WeatherData, isCurrentLocation: Bool = false) {
        if isCurrentLocation {
            guard let cachedWeather = realm?.objects(CachedWeather.self).first(where: {$0.isCurrentLocationWeather == true}) else {
                return
            }
            writeUpdatesInRealm(cachedWeather: cachedWeather, weather: weather)
            
        } else {
            guard let cachedWeather = realm?.objects(CachedWeather.self).first(where: {$0.city?.fullName == weather.city?.fullName}) else {
                return
            }
            writeUpdatesInRealm(cachedWeather: cachedWeather, weather: weather)
        }
    }
    
    private func writeUpdatesInRealm(cachedWeather: CachedWeather, weather: WeatherData) {
        try? realm?.write {
    
            for hourlyWeather in cachedWeather.hourly {
                realm?.delete(hourlyWeather.weathers)
            }
            
            for dailyWeather in cachedWeather.daily {
                realm?.delete(dailyWeather.weathers)
                
                if dailyWeather.feelsLike != nil {
                    realm?.delete(dailyWeather.feelsLike!)
                }
                
                if dailyWeather.temp != nil {
                    realm?.delete(dailyWeather.temp!)
                }
            }
            
            if cachedWeather.city?.location != nil {
                realm?.delete(cachedWeather.city!.location!)
            }
            
            if cachedWeather.city != nil {
                realm?.delete(cachedWeather.city!)
            }
            
            if cachedWeather.current != nil {
                realm?.delete(cachedWeather.current!)
            }
            
            realm?.delete(cachedWeather.daily)
            realm?.delete(cachedWeather.hourly)
            guard let city = weather.city else {
                return
            }
            cachedWeather.timezoneOffset = weather.timezoneOffset
            cachedWeather.city = getCachedCity(city)
            cachedWeather.current = getCachedCurrent(weather)
            cachedWeather.hourly.append(objectsIn: getCachedHourly(weather.hourly))
            cachedWeather.daily.append(objectsIn: getCachedDaily(weather.daily))
        }
    }
    
    private func getCachedWeatherDetails(_ weathers: [Weather]) -> [CachedWeatherDetails] {
        var cachedWeatherDetail = [CachedWeatherDetails]()
        for weather in weathers {
            let cachedWeather = CachedWeatherDetails()
            cachedWeather.main = weather.main
            cachedWeather.weatherDescription = weather.weatherDescription
            cachedWeatherDetail.append(cachedWeather)
        }
        return cachedWeatherDetail
    }
    
    private func getCachedCity(_ city: City) -> CachedCity {
        let cachedLocation = CachedLocation()
        cachedLocation.latitude = city.location.latitude
        cachedLocation.longitude = city.location.longitude
        let cachedCity = CachedCity()
        cachedCity.fullName = city.fullName
        cachedCity.location = cachedLocation
        return cachedCity
    }
    
    private func getCachedCurrent(_ weather: WeatherData) -> CachedHourly {
        let cachedCurrent = CachedHourly()
        cachedCurrent.dt = weather.current.dt
        cachedCurrent.humidity = weather.current.humidity
        cachedCurrent.sunrise = weather.current.sunrise ?? 0
        cachedCurrent.sunset = weather.current.sunset ?? 0
        cachedCurrent.temp = weather.current.temp
        cachedCurrent.feelsLike = weather.current.feelsLike
        cachedCurrent.windSpeed = weather.current.windSpeed
        cachedCurrent.uvi = weather.current.uvi
        cachedCurrent.windDeg = weather.current.windDeg
        cachedCurrent.clouds = weather.current.clouds
        cachedCurrent.pop = weather.current.pop ?? 0
        
        let cachedWeatherDetails = getCachedWeatherDetails(weather.current.weather)
        for cachedWeather in cachedWeatherDetails {
            cachedCurrent.weathers.append(cachedWeather)
        }
        
        return cachedCurrent
    }
    
    private func getCachedHourly(_ hours: [Hourly]) -> [CachedHourly] {
        var cachedHours = [CachedHourly]()
        for hour in hours {
            let cachedHour = CachedHourly()
            let cachedWeatherDetails = getCachedWeatherDetails(hour.weather)
            
            for cachedWeather in cachedWeatherDetails {
                cachedHour.weathers.append(cachedWeather)
            }
            cachedHour.dt = hour.dt
            cachedHour.humidity = hour.humidity
            cachedHour.sunrise = hour.sunrise ?? 0
            cachedHour.sunset = hour.sunset ?? 0
            cachedHour.temp = hour.temp
            cachedHour.feelsLike = hour.feelsLike
            cachedHour.windSpeed = hour.windSpeed
            cachedHour.uvi = hour.uvi
            cachedHour.windDeg = hour.windDeg
            cachedHour.clouds = hour.clouds
            cachedHour.pop = hour.pop ?? 0
            cachedHours.append(cachedHour)
        }
        return cachedHours
    }
    
    private func getCachedDaily(_ days: [Daily]) -> [CachedDaily] {
        var cachedDays = [CachedDaily]()
        for day in days {
            let cachedDay = CachedDaily()
            
            let cachedWeatherDetails = getCachedWeatherDetails(day.weather)
            
            for cachedWeather in cachedWeatherDetails {
                cachedDay.weathers.append(cachedWeather)
            }
            cachedDay.dt =  day.dt
            cachedDay.humidity = day.humidity
            cachedDay.sunrise = day.sunrise
            cachedDay.sunset = day.sunset
            cachedDay.moonrise = day.moonrise
            cachedDay.moonset = day.moonset
            cachedDay.moonPhase = day.moonPhase
            cachedDay.windSpeed = day.windSpeed
            cachedDay.uvi = day.uvi
            cachedDay.windDeg = day.windDeg
            cachedDay.clouds = day.clouds
            cachedDay.pop = day.pop
            
            let cachedFeelsLike = CachedFeelsLike()
            cachedFeelsLike.day = day.feelsLike.day
            cachedFeelsLike.night = day.feelsLike.night
            cachedDay.feelsLike = cachedFeelsLike
            
            let cachedTemp = CachedTemp()
            cachedTemp.day = day.temp.day
            cachedTemp.max = day.temp.max
            cachedTemp.min = day.temp.min
            cachedTemp.night = day.temp.night
            cachedDay.temp = cachedTemp
            
            cachedDays.append(cachedDay)
        }
        return cachedDays
    }
    
}

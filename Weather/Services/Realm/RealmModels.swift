//
//  RealmModels.swift
//  Weather
//
//  Created by Егор Никитин on 24.05.2021.
//

import Foundation
import RealmSwift


@objcMembers class CachedWeather: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var city: CachedCity? = nil
    dynamic var current: CachedHourly? = nil
    dynamic var timezoneOffset: Int = 0
    dynamic var isCurrentLocationWeather: Bool = false
    let moscowTimeOffset: Int = 10800
    var hourly = List<CachedHourly>()
    var daily = List<CachedDaily>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(city: CachedCity, current: CachedHourly, timezoneOffset: Int, hourly: [CachedHourly], daily:[CachedDaily]) {
        self.init()
        self.city = city
        self.current = current
        self.timezoneOffset = timezoneOffset
        self.hourly.append(objectsIn: hourly)
        self.daily.append(objectsIn: daily)
    }
}

@objcMembers class CachedHourly: Object {
    dynamic var dt = 0
    dynamic var humidity = 0
    dynamic var sunrise = 0
    dynamic var sunset = 0
    dynamic var temp = 0.0
    dynamic var feelsLike = 0.0
    dynamic var windSpeed = 0.0
    dynamic var uvi = 0.0
    dynamic var windDeg = 0
    dynamic var clouds = 0
    dynamic var pop = 0.0
    let weathers = List<CachedWeatherDetails>()
    
    var parentCachedWeather = LinkingObjects(fromType: CachedWeather.self, property: "hourly")
    
    convenience init(weathers: [CachedWeatherDetails]) {
        self.init()
        self.weathers.append(objectsIn: weathers)
    }
}

@objcMembers class CachedDaily: Object {
    dynamic var dt = 0
    dynamic var sunrise = 0
    dynamic var sunset = 0
    dynamic var moonrise = 0
    dynamic var moonset = 0
    dynamic var moonPhase = 0.0
    dynamic var temp: CachedTemp? = nil
    dynamic var feelsLike: CachedFeelsLike? = nil
    dynamic var humidity = 0
    dynamic var windSpeed = 0.0
    dynamic var windDeg = 0
    dynamic var clouds = 0
    dynamic var pop = 0.0
    dynamic var uvi = 0.0
    
    var parentCachedWeather = LinkingObjects(fromType: CachedWeather.self, property: "daily")
    
    let weathers = List<CachedWeatherDetails>()
    
    convenience init(weathers: [CachedWeatherDetails]) {
        self.init()
        self.weathers.append(objectsIn: weathers)
    }
}

@objcMembers class CachedTemp: Object {
    dynamic var day = 0.0
    dynamic var min = 0.0
    dynamic var max = 0.0
    dynamic var night = 0.0
}

@objcMembers class CachedFeelsLike: Object {
    dynamic var day = 0.0
    dynamic var night = 0.0
}

class CachedWeatherDetails: Object {
    @objc dynamic var main: String = ""
    @objc dynamic var weatherDescription: String = ""
    
    var parentCachedCurrent = LinkingObjects(fromType: CachedHourly.self, property: "weathers")
    var parentCachedDaily = LinkingObjects(fromType: CachedDaily.self, property: "weathers")
}

@objcMembers class CachedCity: Object {
    
    dynamic var location: CachedLocation? = nil
    dynamic var fullName: String = ""
}

@objcMembers class CachedLocation: Object {
    
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    
}

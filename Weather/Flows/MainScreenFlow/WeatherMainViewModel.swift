//
//  WeatherMainViewModel.swift
//  Weather
//
//  Created by Егор Никитин on 11.05.2021.
//

import UIKit

protocol WeatherMainViewModelOutput {
    //var weatherDataStorage: WeatherData? { get }
    var onWeatherLoaded: ((Bool)->Void)? { get set }
    var onCityLoaded: ((Bool, String?)->Void)? { get set }
    var onLoadData: ((MainWeatherControllerState)->Void)? {get set}
    var onLoadCityWeather: ((String)->Void)? {get set}
    func configureMainInformationView() -> (dailyTemperature: String, currentTemperature: String, descriptionWeather: String, cloudy: String, windSpeed: String, humidity: String, sunrise: String, sunset: String, currentDate: String)?
    func configureHourlyItem(with object: CachedHourly) -> (time: String, image: UIImage?, temperature: String)?
    func configureDailyItem(with object: CachedDaily) -> (dayDate: String, image: UIImage?, humidity: String, descriptionWeather: String, temperature: String)?
    func getHourlyWeatherArray() -> [CachedHourly]
    func getDailyWeatherArray() -> [CachedDaily]
    func configureCityName() -> NSMutableAttributedString?
}


final class WeatherMainViewModel: WeatherMainViewModelOutput {
    
    var onWeatherLoaded: ((Bool)->Void)?
    
    var onCityLoaded: ((Bool, String?)->Void)?
    
    lazy var onLoadData: ((MainWeatherControllerState)->Void)? = { [weak self] state in
        self?.loadWeatherData(stateVC: state)
        //self?.onCityLoaded?(false, self?.cachedWeather?.city?.fullName)
    }
    
    lazy var onLoadCityWeather: ((String)->Void)? = { [weak self] cityName in
        self?.loadCityWeather(cityName: cityName)
    }
    
    var cachedWeather: CachedWeather?
    
    //var weatherDataStorage: WeatherData?
    
    public func configureMainInformationView() -> (dailyTemperature: String, currentTemperature: String, descriptionWeather: String, cloudy: String, windSpeed: String, humidity: String, sunrise: String, sunset: String, currentDate: String)? {
        guard let object = cachedWeather else {
            return nil
        }
        let minTempStr = String(format: "%.0f", convertTemperature(object.daily.first?.temp?.min ?? 0))
        let maxTempStr = String(format: "%.0f", convertTemperature(object.daily.first?.temp?.max ?? 0))
        let currentTempStr = String(format: "%.0f", convertTemperature(object.current?.temp ?? 0))
        let dailyTemperature = minTempStr + "º /" + maxTempStr + "º"
        let currentTemperature = currentTempStr + "º"
        let descriptionWeather = object.current?.weathers.first?.weatherDescription ?? "".uppercasedFirstLetter()
        let cloudy = "\(object.current?.clouds ?? 0)"
        let windSpeed = convertSpeed(speed: object.current?.windSpeed ?? 0)
        let humidity = "\(object.current?.humidity ?? 0)%"
        let sunrise = makeSunTimeString(with: object, isSunrise: true)
        let sunset = makeSunTimeString(with: object, isSunrise: false)
        let currentDate = makeCurrentDateString(with: object)
        
        return (dailyTemperature, currentTemperature, descriptionWeather, cloudy, windSpeed, humidity, sunrise, sunset, currentDate)
        
    }
    
    public func configureHourlyItem(with object: CachedHourly) -> (time: String, image: UIImage?, temperature: String)? {
        guard let weather = cachedWeather else {
            return nil
        }
        let hourlyTempStr = String(format: "%.0f", convertTemperature(object.temp))
        let temperature = hourlyTempStr + "º"
        let localData = TimeInterval(weather.timezoneOffset - weather.moscowTimeOffset)
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.dt) + localData)
        let formatter = DateFormatter()
        formatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh:mm" : "HH:mm"
        let time = formatter.string(from: date as Date)
        let image = setupWeatherImage(weather: object.weathers.first?.main)
        return (time, image, temperature)
    }
    
    public func configureDailyItem(with object: CachedDaily) -> (dayDate: String, image: UIImage?, humidity: String, descriptionWeather: String, temperature: String)? {
        guard let weather = cachedWeather else {
            return nil
        }
        let localData = TimeInterval(weather.timezoneOffset - weather.moscowTimeOffset)
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.dt) + localData)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        let dayDate = formatter.string(from: date as Date)
        let image = setupWeatherImage(weather: object.weathers.first?.main)
        let humidity = "\(object.humidity)%"
        let descriptionWeather = "\(object.weathers.first?.weatherDescription ?? "")".uppercasedFirstLetter()
        let minTempStr = String(format: "%.0f", convertTemperature(object.temp?.min ?? 0))
        let maxTempStr = String(format: "%.0f", convertTemperature(object.temp?.max ?? 0))
        let temperature = minTempStr + "º-" + maxTempStr + "º"
        
        return (dayDate, image, humidity, descriptionWeather, temperature)
    }
    
    public func configureCityName() -> NSMutableAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        guard let cityName = cachedWeather?.city?.fullName else {
            return nil
        }
        return NSMutableAttributedString(string: cityName, attributes: [NSAttributedString.Key.kern: 0.36, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    public func getHourlyWeatherArray() -> [CachedHourly] {
        guard let weather = cachedWeather else {
            return []
        }
        //print("h: \(weather.hourly.count), d:\(weather.daily.count)")
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
    
    public func getDailyWeatherArray() -> [CachedDaily] {
        guard let weather = cachedWeather else {
            return []
        }
        var wetherArray = [CachedDaily]()
        for hourlyWeather in weather.daily {
            wetherArray.append(hourlyWeather)
        }
        if !wetherArray.isEmpty {
            wetherArray.removeFirst()
        }
        
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
    
    private func loadCityWeather(cityName: String) {
        NetworkService.getGeolocationOfCity(cityName: cityName) { [weak self] (city) in
            if city != nil, let cityLocation = city?.location {
                self?.loadNewWeather(locationCoordinate: cityLocation, city: city!)
            } else {
                self?.onCityLoaded?(false, city?.fullName)
            }

        }
    }
    
    private func loadNewWeather(locationCoordinate: LocationCoordinate, city: City) {
        NetworkService.getWeatherData(locationCoordinate: locationCoordinate) { [weak self] (weatherData) in
            if var weatherData = weatherData {
                weatherData.city = city
                guard let newCachedWeather = RealmDataManager.sharedInstance.getNewCachedWeather(weatherData) else {return}
                self?.cachedWeather = newCachedWeather
                RealmDataManager.sharedInstance.addCachedWeather(weatherData)
                self?.onWeatherLoaded?(true)
                self?.onCityLoaded?(true, city.fullName)
            } else {
                self?.onWeatherLoaded?(false)
            }
            
        }
    }
    
    private func loadWeather(locationCoordinate: LocationCoordinate, isNeedLoadCityName: Bool, city: City) {
        NetworkService.getWeatherData(locationCoordinate: locationCoordinate) { [weak self] (weatherData) in
            if var weatherData = weatherData {
                weatherData.city = city
                guard let newCachedWeather = RealmDataManager.sharedInstance.getNewCachedWeather(weatherData) else {return} //, let cachedWeather = self?.cachedWeather
                self?.cachedWeather = newCachedWeather
                RealmDataManager.sharedInstance.updateCachedWeather(weatherData)
                self?.onWeatherLoaded?(true)
            } else {
                self?.onWeatherLoaded?(false)
            }
            
        }
    }
    
    private func loadCityName(location: LocationCoordinate) {
        NetworkService.getNameOfCity(location: location) { [weak self] (city) in
            if let city = city {
                self?.onCityLoaded?(true, city.fullName)
            } else {
                self?.onCityLoaded?(false, city?.fullName)
            }
        }
    }
    
    private func loadWeatherData(stateVC: MainWeatherControllerState) {
        switch stateVC {
        case .currentLocationWeather:
            LocationManager.sharedInstance.getCurrentLocation { (locationCoordinate) in
                //self.loadWeather(locationCoordinate: locationCoordinate, isNeedLoadCityName: true)
            }
        case .selectedCityWeather:
            guard let locationCoordinate = self.cachedWeather?.city?.location else {
                break
            }
            let location = LocationCoordinate(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            let city = City(location: location, fullName: self.cachedWeather?.city?.fullName ?? "unknown")
            loadWeather(locationCoordinate: location, isNeedLoadCityName: false, city: city)
        case .emptyWithPlus: break
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
    
    private func makeSunTimeString(with object: CachedWeather, isSunrise: Bool) -> String {
        let localData = TimeInterval(object.timezoneOffset - object.moscowTimeOffset)
        let sunFormatter = DateFormatter()
        sunFormatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh:mm a" : "HH:mm"
        
        if isSunrise {
            let sunriseDate = NSDate(timeIntervalSince1970: TimeInterval(object.current?.sunrise ?? 0) + localData)
            return sunFormatter.string(from: sunriseDate as Date)
        } else {
            let sunsetDate = NSDate(timeIntervalSince1970: TimeInterval(object.current?.sunset ?? 0) + localData)
            return sunFormatter.string(from: sunsetDate as Date)
        }
    }

    private func makeCurrentDateString(with object: CachedWeather) -> String {
        let localData = TimeInterval(object.timezoneOffset - object.moscowTimeOffset)
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.current?.dt ?? 0) + localData)
        let formatter = DateFormatter()
        if UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) {
            formatter.dateFormat = "hh:mm a, E d MMM"
        } else {
            formatter.dateFormat = "HH:mm, E d MMM"
        }
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date as Date)
    }
    
}

//
//  WeatherMainViewModel.swift
//  Weather
//
//  Created by Егор Никитин on 11.05.2021.
//

import UIKit

protocol WeatherMainViewModelOutput {
    var cachedWeather: CachedWeather? { get }
    var onWeatherLoaded: ((Bool)->Void)? { get set }
    var onCityLoaded: ((Bool, String?)->Void)? { get set }
    var onLoadData: ((MainWeatherControllerState, Int)->Void)? {get set}
    var onLoadNewCityWeather: ((String)->Void)? {get set}
    func configureMenuView() -> (cityName: NSMutableAttributedString, isOnNotifications: Bool, isDailyShow: Bool, temperatureUnit: NSMutableAttributedString, windSpeedUnit: NSMutableAttributedString, visibilityUnit: NSMutableAttributedString, timeFormat: NSMutableAttributedString)
    func configureMainInformationView() -> (dailyTemperature: String, currentTemperature: String, descriptionWeather: String, cloudy: String, windSpeed: String, humidity: String, sunrise: String, sunset: String, currentDate: String)?
    func configureHourlyItem(with object: CachedHourly) -> (time: String, image: UIImage?, temperature: String)?
    func configureDailyItem(with object: CachedDaily) -> (dayDate: String, image: UIImage?, humidity: String, descriptionWeather: String, temperature: String)?
    func getHourlyWeatherArray() -> [CachedHourly]
    func getDailyWeatherArray() -> [CachedDaily]
    func configureCityName() -> NSMutableAttributedString?
}


final class WeatherMainViewModel: WeatherMainViewModelOutput {
    
    //MARK: - Properties

    var onWeatherLoaded: ((Bool) -> Void)?
    
    var onCityLoaded: ((Bool, String?) -> Void)?
    
    private var viewControllerIndex: Int?
    
    lazy var onLoadData: ((MainWeatherControllerState, Int) -> Void)? = { [weak self] state, index in
        self?.viewControllerIndex = index
        self?.loadCityAndWeatherData(stateVC: state)
    }
    
    lazy var onLoadNewCityWeather: ((String) -> Void)? = { [weak self] cityName in
        self?.loadNewCityAndWeatherData(cityName: cityName)
    }
    
    var cachedWeather: CachedWeather?
    
    //MARK: - Configure Methods
    
    public func configureMenuView() -> (cityName: NSMutableAttributedString, isOnNotifications: Bool, isDailyShow: Bool, temperatureUnit: NSMutableAttributedString, windSpeedUnit: NSMutableAttributedString, visibilityUnit: NSMutableAttributedString, timeFormat: NSMutableAttributedString) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        var currentLocationCityNameString = ""
        if let currentLocationCityFullNameUnwrapped = RealmDataManager.sharedInstance.getCurrentLocationCachedWeather()?.city?.fullName {
            if let lastIndex = currentLocationCityFullNameUnwrapped.lastIndex(of: ",") {
                currentLocationCityNameString = String(currentLocationCityFullNameUnwrapped[..<lastIndex])  // "www.stackoverflow"
            }
        } else {
            currentLocationCityNameString = "Не выбранно"
        }
        let currentLocationCityName = NSMutableAttributedString(string: currentLocationCityNameString, attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let isOnNotifications = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isNotifyBoolKey.rawValue) ? true : false
        
        let isDailyShow = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isDailyShowBoolKey.rawValue) ? true : false
        
        let temperatureText = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isCelsiusChosenBoolKey.rawValue) ? "C" : "F"
        let temperatureUnit = NSMutableAttributedString(string: temperatureText, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let windText = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isMiChosenBoolKey.rawValue) ? "mile\\s" : "m\\s"
        let windSpeedUnit = NSMutableAttributedString(string: windText, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let visibilityText = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isMiChosenBoolKey.rawValue) ? "Mile" : "Km"
        let visibilityUnit = NSMutableAttributedString(string: visibilityText, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let timeText = UserDefaults.standard.bool(forKey: UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "12 часов" : "24 часа"
        let timeFormat = NSMutableAttributedString(string: timeText, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        return (currentLocationCityName, isOnNotifications, isDailyShow, temperatureUnit, windSpeedUnit, visibilityUnit, timeFormat)
        
    }
    
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
    
    //MARK: - Network Methods
    
    private func loadCityAndWeatherData(stateVC: MainWeatherControllerState) {
        switch stateVC {
        case .currentLocationWeather:
            LocationManager.sharedInstance.getCurrentLocation { [weak self] (locationCoordinate) in
                self?.loadCurrentLocationWeather(locationCoordinate: locationCoordinate)
            }
        case .selectedCityWeather:
            guard let locationCoordinate = self.cachedWeather?.city?.location else {
                break
            }
            let location = LocationCoordinate(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            let city = City(location: location, fullName: self.cachedWeather?.city?.fullName ?? "unknown")
            loadWeather(locationCoordinate: location, city: city)
        case .emptyWithPlus: break
        }
        
    }
    
    private func loadCurrentLocationWeather(locationCoordinate: LocationCoordinate) {
        NetworkService.getWeatherData(locationCoordinate: locationCoordinate) { [weak self] (weatherData) in
            if let weatherData = weatherData {
                self?.loadCurrentLocationCityName(locationCoordinate: locationCoordinate, weatherData: weatherData)
            } else {
                self?.onWeatherLoaded?(false)
            }
        }
    }
    
    private func loadCurrentLocationCityName(locationCoordinate: LocationCoordinate, weatherData: WeatherData) {
        NetworkService.getNameOfCity(location: locationCoordinate) { [weak self] (city) in
            if let city = city {
                var newWeatherData = weatherData
                newWeatherData.city = city
                guard let newCachedWeather = RealmDataManager.sharedInstance.getNewCachedWeather(newWeatherData) else {return}
                self?.cachedWeather = newCachedWeather
                self?.chooseActionForRealm(weatherData: newWeatherData)
                self?.onWeatherLoaded?(true)
                self?.onCityLoaded?(true, city.fullName)
                self?.makeWeatherWidgetJSON(weather: newWeatherData)
            } else {
                self?.onCityLoaded?(false, city?.fullName)
            }
        }
    }
    
    private func makeWeatherWidgetJSON(weather: WeatherData) {
        var dailyWeatherWidgetArray = [DailyWeatherWidget]()
        for (index, dayWeather) in weather.daily.enumerated() {
            if index >= 1 && index <= 5 {
                let localData = TimeInterval(weather.timezoneOffset - weather.moscowTimeOffset)
                let date = NSDate(timeIntervalSince1970: TimeInterval(dayWeather.dt) + localData)
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.dateFormat = "E"
                let dayDate = formatter.string(from: date as Date).lowercased()
                let dailyWeatherWidget = DailyWeatherWidget(date: dayDate, precipitation: Int(dayWeather.pop * 100), weatherMain: dayWeather.weather.first?.main ?? "", minTemperature: Int(dayWeather.temp.min), maxTemperature: Int(dayWeather.temp.max))
                dailyWeatherWidgetArray.append(dailyWeatherWidget)
            }
        }
        
        var cityName = ""
        if let currentLocationCityFullNameUnwrapped = weather.city?.fullName {
            if let lastIndex = currentLocationCityFullNameUnwrapped.lastIndex(of: ",") {
                cityName = String(currentLocationCityFullNameUnwrapped[..<lastIndex])
            }
        }
        let weatherForWidget = WeatherWidgetData(date: Date(),
                                                 currentWeatherTemperature: Int(weather.current.temp),
                                                 currentWeatherDescription: weather.current.weather.first?.weatherDescription.uppercasedFirstLetter() ?? "",
                                                 cityName: cityName,
                                                 mainWeather: weather.current.weather.first?.main ?? "",
                                                 dailyWeather: dailyWeatherWidgetArray)
        let encoder = JSONEncoder()
        
        do {
            let dataToSave = try encoder.encode(weatherForWidget)
            (UserDefaults(suiteName: "group.WeatherApp.Contents"))?.setValue(dataToSave, forKey: "WeatherForWidget")
            weatherForWidget.reloadWidget()
        } catch {
            print("Error: Can't write contents")
            return
        }
    }
    
    private func chooseActionForRealm(weatherData: WeatherData) {
        if RealmDataManager.sharedInstance.isRealmContainsCurrentLocationCachedWeather() {
            RealmDataManager.sharedInstance.updateCachedWeather(weatherData, isCurrentLocation: true)
        } else {
            RealmDataManager.sharedInstance.addCachedWeather(weatherData, isCurrentLocation: true)
        }
    }
    
    private func loadWeather(locationCoordinate: LocationCoordinate, city: City) {
        NetworkService.getWeatherData(locationCoordinate: locationCoordinate) { [weak self] (weatherData) in
            if var weatherData = weatherData {
                weatherData.city = city
                guard let newCachedWeather = RealmDataManager.sharedInstance.getNewCachedWeather(weatherData) else {return}
                self?.cachedWeather = newCachedWeather
                RealmDataManager.sharedInstance.updateCachedWeather(weatherData)
                self?.onWeatherLoaded?(true)
                if self?.viewControllerIndex == 0 && !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isTrackingBoolKey.rawValue) {
                    self?.makeWeatherWidgetJSON(weather: weatherData)
                }
            } else {
                self?.onWeatherLoaded?(false)
            }
        }
    }
    
    private func loadNewCityAndWeatherData(cityName: String) {
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
    

    //MARK: - Converting Methods
    
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

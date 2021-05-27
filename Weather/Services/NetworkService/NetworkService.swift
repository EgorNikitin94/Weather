//
//  NetworkService.swift
//  Weather
//
//  Created by Егор Никитин on 04.05.2021.
//

import Foundation
import Alamofire

final class NetworkService {
    
    static func getDataFromServer(with url: URL, completion: @escaping ((Data)->Void)) {
        AF.request(url).response { response in
            
            guard response.error == nil else {
                print(response.error?.localizedDescription ?? "")
                return
            }
            
            if let data = response.data {
                //print(String(data: data, encoding: .utf8) ?? "empty data")
                completion(data)
            }
        }
        
    }
    
    static func getWeatherData(locationCoordinate: LocationCoordinate, completion: @escaping ((WeatherData?) -> Void)) {
        let apiString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(locationCoordinate.latitude)&lon=\(locationCoordinate.longitude)&exclude=minutely,alerts&units=metric&lang=ru&appid=\(ApiKeys.openWeather.rawValue)"
        
        guard let url = URL(string: apiString) else { return }
        
        NetworkService.getDataFromServer(with: url) { (data) in
            
            do {
                let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(weather)
            } catch let error as NSError {
                completion(nil)
                print(error.debugDescription)
            }
            
        }
    }
    
    /// отдает почасовое качество воздуха на пять дней, а нужно 7 дней. На семь дней нет бесплатного доступа
//    static func airQualityData(locationCoordinate: LocationCoordinate, completion: @escaping ((WeatherData?) -> Void)) {
//
//        let apiString = "http://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=50&lon=50&appid=\(ApiKeys.openWeather.rawValue)"
//
//        guard let url = URL(string: apiString) else { return }
//
//        NetworkService.getDataFromServer(with: url) { (data) in
//
//            do {
//                let weather = try JSONDecoder().decode(WeatherData.self, from: data)
//                completion(weather)
//            } catch let error as NSError {
//                completion(nil)
//                print(error.debugDescription)
//            }
//
//        }
//    }
    
    private static func selectCityName(data: CityData) -> String? {
        let administrativeAreaName = data.response.geoObjectCollection.featureMember.first?.geoObject.metaDataProperty.geocoderMetaData.addressDetails.country.administrativeArea?.administrativeAreaName
        
        let localityNameOptional = data.response.geoObjectCollection.featureMember.first?.geoObject.metaDataProperty.geocoderMetaData.addressDetails.country.administrativeArea?.locality?.localityName
        
        let localityNameOptionalSub = data.response.geoObjectCollection.featureMember.first?.geoObject.metaDataProperty.geocoderMetaData.addressDetails.country.administrativeArea?.subAdministrativeArea?.locality?.localityName
        
        
        if localityNameOptional != nil {
            return localityNameOptional
        } else if localityNameOptionalSub != nil {
            return localityNameOptionalSub
        } else {
            return administrativeAreaName
        }
        
    }
    
    private static func makeFullCityName(cityName: String, countryName: String) -> String {
        if countryName == "Соединённые Штаты Америки" {
            return "\(cityName),США"
        } else {
            return "\(cityName),\(countryName)"
        }
    }
    
    static func getGeolocationOfCity(cityName: String, completion: @escaping ((City?) -> Void)) {
        let apiString =  "https://geocode-maps.yandex.ru/1.x/?apikey=\(ApiKeys.yandexApi.rawValue)&geocode=\(cityName)&format=json&lang=ru_RU"
        
        if let encoded = apiString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded) {
            
            NetworkService.getDataFromServer(with: url) { (data) in
                
                do {
                    let serverAnswer = try JSONDecoder().decode(CityData.self, from: data)
                    
                    
                    let localityNameOptionalContainer: String? = selectCityName(data: serverAnswer)
                    
                    
                    guard let coordinate = serverAnswer.response.geoObjectCollection.featureMember.first?.geoObject.getCoordinate(),
                          let cityName = localityNameOptionalContainer,
                          let countryName = serverAnswer.response.geoObjectCollection.featureMember.first?.geoObject.metaDataProperty.geocoderMetaData.addressDetails.country.countryName else  {
                        return
                    }
                    
                    let fullName = makeFullCityName(cityName: cityName, countryName: countryName)
                    
                    completion(City(location: coordinate, fullName: fullName))
                    
                } catch let error as NSError {
                    completion(nil)
                    print(error.debugDescription)
                }
                
            }
        }
        
    }
    
    static func getNameOfCity(location: LocationCoordinate, completion: @escaping ((City?) -> Void)) {
        let apiString = "https://geocode-maps.yandex.ru/1.x/?apikey=\(ApiKeys.yandexApi.rawValue)&geocode=\(location.longitude),\(location.latitude)&format=json&lang=ru_RU&results=1"
        
        if let encoded = apiString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded) {
            
            NetworkService.getDataFromServer(with: url) { (data) in
                
                do {
                    let serverAnswer = try JSONDecoder().decode(CityData.self, from: data)
                    
                    let localityNameOptionalContainer: String? = selectCityName(data: serverAnswer)
                    
                    guard let cityName = localityNameOptionalContainer,
                          let countryName = serverAnswer.response.geoObjectCollection.featureMember.first?.geoObject.metaDataProperty.geocoderMetaData.addressDetails.country.countryName else  {
                        return
                    }
                    
                    let fullName = makeFullCityName(cityName: cityName, countryName: countryName)
                    
                    completion(City(location: location, fullName: fullName))
                    
                } catch let error as NSError {
                    completion(nil)
                    print(error.debugDescription)
                }
                
            }
        }
        
    }
    
}



//
//  NetworkService.swift
//  Weather
//
//  Created by Егор Никитин on 04.05.2021.
//

import Foundation
import Alamofire

final class NetworkService {
    
    static func getWeatherData(locationCoordinate: LocationCoordinate, completion: @escaping ((WeatherData) -> Void)) {
        
        let apiString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(locationCoordinate.latitude)&lon=\(locationCoordinate.longitude)&exclude=minutely,alerts&units=metric&lang=ru&appid=\(ApiKeys.openWeather.rawValue)"
        
        AF.request(apiString).response { response in
            
            guard response.error == nil else {
                print(response.error?.localizedDescription ?? "")
                return
            }
            
            if let data = response.data {
                print(String(data: data, encoding: .utf8) ?? "empty data")
                do {
                    let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                    completion(weather)
                } catch let error as NSError {
                    print(error.debugDescription)
                }
            }
        }
    }
    
}



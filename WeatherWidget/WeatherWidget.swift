//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Егор Никитин on 28.05.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    private let snapshotEntry = WeatherWidgetData(date: Date(),
                                                  currentWeatherTemperature: 19,
                                                  currentWeatherDescription: "Ясно",
                                                  cityName: "Сан-Франциско",
                                                  mainWeather: "Cloudy",
                                                  dailyWeather: [DailyWeatherWidget(date: "чт", precipitation: 20, weatherMain: "Rain", minTemperature: 5, maxTemperature: 15),
                                                                 DailyWeatherWidget(date: "пт", precipitation: 19, weatherMain: "Clouds", minTemperature: 12, maxTemperature: 20),
                                                                 DailyWeatherWidget(date: "сб", precipitation: 10, weatherMain: "Clear", minTemperature: 23, maxTemperature: 25),
                                                                 DailyWeatherWidget(date: "вс", precipitation: 0, weatherMain: "Clear", minTemperature: 20, maxTemperature: 23),
                                                                 DailyWeatherWidget(date: "пн", precipitation: 99, weatherMain: "Rain", minTemperature: 16, maxTemperature: 19) ]
                                                )
    
    func placeholder(in context: Context) -> WeatherWidgetData {
        snapshotEntry
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WeatherWidgetData) -> ()) {
        let entry = snapshotEntry
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WeatherWidgetData] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            var weather = getWeatherWidgetDataFromJSON()
            weather.date = entryDate
            let entry = weather
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    private func getWeatherWidgetDataFromJSON() -> WeatherWidgetData {
        let decoder = JSONDecoder()
        if let data = (UserDefaults(suiteName: "group.WeatherApp.Contents"))?.data(forKey: "WeatherForWidget") {
            do {
                return try decoder.decode(WeatherWidgetData.self, from: data)
            } catch {
                print("Error: Can't decode contents")
                return  snapshotEntry
            }
        } else {
            return  snapshotEntry
        }
        
    }
}

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color.init(AppColors.sharedInstance.accentBlue)
            
            Image("Cloud")
                .resizable()
                .frame(width: 185, height: 95)
                .offset(x: 90, y: -45)
            
            VStack(spacing: 5) {
                
                HStack(spacing: 5) {
                    
                    Image(setupWeatherImage(weather: entry.mainWeather))
                        .resizable()
                        .frame(width: 28, height: 23)
                        .padding(.leading, 12)
                    
                    Text("\(entry.currentWeatherTemperature)º")
                        .foregroundColor(.white)
                        .font(.custom("Rubik-Regular", size: 30))
                    
                    Spacer()
                    
                    Text(entry.currentWeatherDescription)
                        .foregroundColor(.white)
                        .font(.custom("Rubik-Regular", size: 14))
                        .padding(.trailing, 15)
                }.padding(.top)
                
                HStack {
                    
                    Spacer()
                    
                    Text(entry.cityName)
                        .foregroundColor(.white)
                        .font(.custom("Rubik-Regular", size: 14))
                        .padding(.trailing, 15)
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    
                    ForEach(entry.dailyWeather, id: \.id) { weather in
                        VStack {
                            
                            Text(weather.date)
                                .foregroundColor(.white)
                                .font(.custom("Rubik-Regular", size: 14))
                            
                            Text("\(weather.precipitation)%")
                                .foregroundColor(.white)
                                .font(.custom("Rubik-Regular", size: 12))
                            
                            Image(setupWeatherImage(weather: weather.weatherMain))
                                .resizable()
                                .frame(width: 17, height: 17)
                            
                            Text("\(weather.minTemperature)º/\(weather.maxTemperature)º")
                                .foregroundColor(Color.init(UIColor(red: 0.804, green: 0.767, blue: 0.767, alpha: 1)))
                                .font(.custom("Rubik-Regular", size: 12))
                            
                        }
                    }
                }.padding(.bottom, 20)
            }
        }
    }
    
    private func setupWeatherImage(weather: String?) -> String {
        switch weather {
        case "Clear":
            return "Sun"
        case "Rain":
            return "CloudRain"
        case "Clouds":
            return "Cloudy"
        case "Fog":
            return "Clouds"
        default:
            return "Cloudy"
        }
    }
}


@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather")
        .description("Weather for current location")
        .supportedFamilies([.systemMedium])
    }
}

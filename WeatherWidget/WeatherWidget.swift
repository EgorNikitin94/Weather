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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    //    let wether = RealmDataManager.sharedInstance.getCurrentLocationCachedWeather()
    let date: Date
    let configuration: ConfigurationIntent
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
                    
                    Image("Cloudy")
                        .resizable()
                        .frame(width: 28, height: 23)
                        .padding(.leading, 12)
                    
                    Text("19º")
                        .foregroundColor(.white)
                        .font(.custom("Rubik-Regular", size: 30))
                    
                    Spacer()
                    
                    Text("Переменная облачность")
                        .foregroundColor(.white)
                        .font(.custom("Rubik-Regular", size: 14))
                        .padding(.trailing, 15)
                }.padding(.top)
                
                HStack {
                    
                    Spacer()
                    
                    Text("Cан-Франциско")
                        .foregroundColor(.white)
                        .font(.custom("Rubik-Regular", size: 14))
                        .padding(.trailing, 15)
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    
                    ForEach(wethers, id: \.id) { weather in
                        VStack {
                            
                            Text(weather.day)
                                .foregroundColor(.white)
                                .font(.custom("Rubik-Regular", size: 14))
                            
                            Text("\(weather.precipitation)%")
                                .foregroundColor(.white)
                                .font(.custom("Rubik-Regular", size: 12))
                            
                            Image(weather.image)
                            .resizable()
                            .frame(width: 17, height: 17)
                            
                            Text("\(weather.minTemp)º/\(weather.maxTemp)º")
                                .foregroundColor(Color.init(UIColor(red: 0.804, green: 0.767, blue: 0.767, alpha: 1)))
                                .font(.custom("Rubik-Regular", size: 12))
                            
                        }
                    }
                }.padding(.bottom, 20)
            }
        }
    }
}

struct Weather: Identifiable {
    let id = UUID()
    let day: String
    let precipitation: Int
    let image: String
    let minTemp: Int
    let maxTemp: Int
}

let wethers = [Weather(day: "чт", precipitation: 20, image: "CloudRain", minTemp: 5, maxTemp: 15),
               Weather(day: "пт", precipitation: 19, image: "CloudRain", minTemp: 12, maxTemp: 20),
               Weather(day: "сб", precipitation: 10, image: "Sun", minTemp: 23, maxTemp: 25),
               Weather(day: "вс", precipitation: 0, image: "Sun", minTemp: 20, maxTemp: 23),
               Weather(day: "пн", precipitation: 99, image: "Clouds", minTemp: 16, maxTemp: 19),
]

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
        ///Не смог разобраться с этим модификатором. В документации не понятно как он работает и другой информации по его работе я не нашел
//        .onBackgroundURLSessionEvents { (<#String#>, <#@escaping () -> Void#>) in
//            <#code#>
//        }
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

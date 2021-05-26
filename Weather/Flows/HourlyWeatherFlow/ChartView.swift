//
//  ChartView.swift
//  Weather
//
//  Created by Егор Никитин on 23.05.2021.
//

import UIKit

final class ChartView: UIView {
    
    private enum Constants {
        static let margin: CGFloat = 16.0
        static let topBorder: CGFloat = 31.0
        static let bottomBorder: CGFloat = 54.0
        static let viewWidth: CGFloat = 430.0
        static let viewHeight: CGFloat = 152.0
    }
    
    private var hourlyWeather: [CachedHourly]?
    
    private let timezoneOffset: Int
    
    private let moscowTimeOffset: Int
    
    private lazy var graphWidth =  {return self.frame.width - Constants.margin * 2}
    
    private lazy var graphHeight = { return self.frame.height - (98 + 31)}
    
    // Calculate the x point
    private lazy var columnXPoint = { (column: Int) -> CGFloat in
        // Calculate the gap between points
        guard let weather = self.hourlyWeather else { return 0}
        let spacing = self.graphWidth() / CGFloat(weather.count - 1)
        return CGFloat(column) * spacing + Constants.margin + 2
    }
    
    // Calculate the y point
    private lazy var columnYPoint = { (graphPoint: Double, maxValue: Double) -> CGFloat in
        let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * self.graphHeight()
        return self.graphHeight() + Constants.topBorder - yPoint // Переворот графика
    }
    
    init(hourlyWeather: [CachedHourly]?, timezoneOffset: Int, moscowTimeOffset: Int) {
        self.hourlyWeather = hourlyWeather
        self.timezoneOffset = timezoneOffset
        self.moscowTimeOffset = moscowTimeOffset
        super.init(frame: CGRect(x: 0, y: 0, width: Constants.viewWidth, height: Constants.viewHeight))
        setupChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let weather = hourlyWeather else { return }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let weatherTemperatureArray: [Double] = getWeatherTemperatureArray()

        let width = rect.width
        let height = rect.height
        
        let maxValue = getMaxWeatherTemperature(weatherTemperatureArray: weatherTemperatureArray)
        
        // Drawing a line of a temperature graph
        
        AppColors.sharedInstance.dividerColor.setFill()
        AppColors.sharedInstance.dividerColor.setStroke()
        
        let graphPath = UIBezierPath()
        
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(weatherTemperatureArray[0], maxValue)))
        
        for i in 1 ..< weatherTemperatureArray.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(weatherTemperatureArray[i], maxValue))
            graphPath.addLine(to: nextPoint)
        }
        
        graphPath.lineWidth = 0.5
        
        context.saveGState()
        
        // Draw a gradient below the graph
        guard let clippingPath = graphPath.copy() as? UIBezierPath else {
            return
        }
        
        clippingPath.addLine(to: CGPoint(
                                x: columnXPoint(weatherTemperatureArray.count - 1),
                                y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        clippingPath.addClip()
        
        
        let colors = [
            
            UIColor(red: 0.241, green: 0.412, blue: 0.863, alpha: 1).cgColor,
            
            UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor,
            
            UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 0).cgColor
            
        ]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 0.0, 1.0]
        
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: colorLocations
        ) else {
            return
        }
        
        let highestYPoint = columnYPoint(maxValue, maxValue)
        let graphStartPoint = CGPoint(x: Constants.margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: Constants.margin, y: Constants.bottomBorder)
        
        context.drawLinearGradient(
            gradient,
            start: graphStartPoint,
            end: graphEndPoint,
            options: [])
        context.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        
        // Draw the circles on top of the graph stroke
        for i in 0 ..< weatherTemperatureArray.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(weatherTemperatureArray[i], maxValue))
            point.x -= 2
            point.y -= 2
            
            let circle = UIBezierPath(
                ovalIn: CGRect(
                    origin: point,
                    size: CGSize(
                        width: 4,
                        height: 4)
                )
            )
            UIColor.white.setFill()
            UIColor.white.setStroke()
            circle.fill()
        }
        
        // Draw a line of probability of precipitation
        
        let precipitationPath = UIBezierPath()
        
        precipitationPath.move(to: CGPoint(x: 18, y: 116))
        let precipitationPathWidth = width - Constants.margin * 2
        let xPoint = { (column: Int) -> CGFloat in
            let spacing = precipitationPathWidth / CGFloat(weatherTemperatureArray.count - 1)
            return CGFloat(column) * spacing + Constants.margin + 2
        }
        
        let yPoint: CGFloat = 116

        for i in 1 ..< weather.count {
            let nextPoint = CGPoint(x: xPoint(i), y: yPoint)
            precipitationPath.addLine(to: nextPoint)
        }
        
        AppColors.sharedInstance.accentBlue.setFill()
        AppColors.sharedInstance.accentBlue.setStroke()
        
        precipitationPath.stroke()
        
        
        context.saveGState()
        
        // Draw the rectangles on top of the precipitationPath stroke
        
        for i in 0 ..< weatherTemperatureArray.count {
            var point = CGPoint(x: xPoint(i), y: yPoint)
            point.x -= 2
            point.y -= 4
            
            let rectangle = UIBezierPath(rect: CGRect(origin: point, size: CGSize(width: 4, height: 8)))
            AppColors.sharedInstance.accentBlue.setFill()
            AppColors.sharedInstance.accentBlue.setStroke()
            rectangle.fill()
        }
        
        context.saveGState()
        
        // Draw dashesPath
        
        let dashesPath = UIBezierPath()
        
        let  p0 = CGPoint(x: Constants.margin, y: Constants.topBorder)
        dashesPath.move(to: p0)
        
        let  p1 = CGPoint(x: Constants.margin, y: Constants.bottomBorder)
        dashesPath.addLine(to: p1)

        let  p2 = CGPoint(x: graphWidth() + Constants.margin, y: Constants.bottomBorder)
        dashesPath.addLine(to: p2)
        

        let  dashes: [ CGFloat ] = [ 3.0, 3.0 ]
        dashesPath.setLineDash(dashes, count: dashes.count, phase: 0.0)

        dashesPath.lineWidth = 0.5
        AppColors.sharedInstance.dividerColor.set()
        dashesPath.stroke()
        
        
    }
    
    private func getWeatherTemperatureArray() -> [Double] {
        guard let weather = hourlyWeather else { return []}
        var weatherTemperatureArray: [Double] = []
        for i in weather {
            weatherTemperatureArray.append(i.temp)
        }
        
        return weatherTemperatureArray

    }
    
    private func getMaxWeatherTemperature(weatherTemperatureArray: [Double]) -> Double {
        guard let maxValue = weatherTemperatureArray.max() else {
            return 0
        }
        return maxValue
    }
    
    private func setupChart() {
        guard let weather = hourlyWeather else { return }
    
        let weatherTemperatureArray: [Double] = getWeatherTemperatureArray()
        
        let maxValue = getMaxWeatherTemperature(weatherTemperatureArray: weatherTemperatureArray)
        

        for i in 0...weather.count - 1 {
            let hourWeather = weather[i]
            
            configureColumn(hourWeather: hourWeather, i: i, maxValue: maxValue)
        }
        
    }
    
    private func configureColumn(hourWeather: CachedHourly, i: Int, maxValue: Double) {
        let localData = TimeInterval(timezoneOffset - moscowTimeOffset)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        var timeLabelXOffset: CGFloat = 0
        
        var precipitationLabelXOffset: CGFloat = 0
        
        var precipitationLabelCenterXOffset: CGFloat = 0
        
        var precipitationImageXOffset: CGFloat = 0
        
        var precipitationImageCenterXOffset: CGFloat = 0
        
        var temperatureLabelXOffset: CGFloat = 0
        
        if i == 0 {
            timeLabelXOffset = 2
            precipitationLabelXOffset = columnXPoint(i)
            precipitationImageXOffset = columnXPoint(i)
            temperatureLabelXOffset = columnXPoint(i)
        } else if i == 7 {
            timeLabelXOffset = 24
            precipitationLabelXOffset = 0
            precipitationLabelCenterXOffset = columnXPoint(i) - 2
            precipitationImageXOffset = 0
            precipitationImageCenterXOffset = columnXPoint(i) - 2
            temperatureLabelXOffset = columnXPoint(i) - 12
        } else {
            timeLabelXOffset = 13
            precipitationLabelXOffset = 0
            precipitationLabelCenterXOffset = columnXPoint(i)
            precipitationImageXOffset = 0
            precipitationImageCenterXOffset = columnXPoint(i)
            temperatureLabelXOffset = columnXPoint(i)
        }
        
        let timeLabel = UILabel(frame: CGRect(x: columnXPoint(i) - timeLabelXOffset , y: 128, width: 40, height: 16))
        self.addSubview(timeLabel)
        timeLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        timeLabel.font = UIFont(name: "Rubik-Regular", size: 14)
        paragraphStyle.lineHeightMultiple = 0.96
        paragraphStyle.alignment = .left
        let timeInterval = NSDate(timeIntervalSince1970: TimeInterval(hourWeather.dt) + localData)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh:mm a" : "HH:mm"
        timeLabel.attributedText = NSMutableAttributedString(string: timeFormatter.string(from: timeInterval as Date), attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        
        let precipitationLabel = UILabel(frame: CGRect(x: precipitationLabelXOffset, y: 88, width: 23, height: 15))
        if i != 0 {
            precipitationLabel.center.x = precipitationLabelCenterXOffset
        }
        self.addSubview(precipitationLabel)
        precipitationLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        precipitationLabel.font = UIFont(name: "Rubik-Regular", size: 12)
        paragraphStyle.lineHeightMultiple = 1.05
        paragraphStyle.alignment = i != 0 && i != 7 ? .center : .left
        let precipitationValue = (hourWeather.pop) * 100
        let precipitationValueString = String(format: "%.0f", precipitationValue)
        precipitationLabel.attributedText = NSMutableAttributedString(string: precipitationValueString + "%", attributes: [NSAttributedString.Key.kern: 0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let precipitationImage = UIImageView(frame: CGRect(x: precipitationImageXOffset, y: 68, width: 16, height: 16))
        if i != 0 {
            precipitationImage.center.x = precipitationImageCenterXOffset
        }
        self.addSubview(precipitationImage)
        precipitationImage.image = UIImage(named: "CloudRain")
        
        let temperatureLabel = UILabel(frame: CGRect(x: temperatureLabelXOffset, y: 0, width: 25, height: 14))
        temperatureLabel.center.y = columnYPoint(hourWeather.temp, maxValue) - 12
        self.addSubview(temperatureLabel)
        temperatureLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        temperatureLabel.font = UIFont(name: "Rubik-Regular", size: 14)
        paragraphStyle.lineHeightMultiple = 0.84
        paragraphStyle.alignment = .left
        let temperatureValueString = String(format: "%.0f", convertTemperature(hourWeather.temp))
        temperatureLabel.attributedText = NSMutableAttributedString(string: temperatureValueString + "º", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    private func convertTemperature(_ temperature: Double) -> Double {
        if UserDefaults.standard.bool(forKey:UserDefaultsKeys.isCelsiusChosenBoolKey.rawValue) {
            return temperature
        } else {
            //°F
            return (9.0/5.0) * temperature + 32.0
        }
    }
    
}

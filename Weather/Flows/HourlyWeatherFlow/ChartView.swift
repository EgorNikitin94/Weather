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
        static let graphWight: CGFloat = 394.0
        static let graphHeight: CGFloat = 23.0
        
    }
    
    private var hourlyWeather: [Hourly]?
    
    private let timezoneOffset: Int
    
    private let moscowTimeOffset: Int
    
    private var yCircleArray: [CGFloat] = []
    
    private var xRectangleArray: [CGFloat] = []
    
    init(hourlyWeather: [Hourly]?, timezoneOffset: Int, moscowTimeOffset: Int) {
        self.hourlyWeather = hourlyWeather
        self.timezoneOffset = timezoneOffset
        self.moscowTimeOffset = moscowTimeOffset
        super.init(frame: CGRect(x: 0, y: 0, width: 430, height: 152))
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
        
        var weatherTemperatureArray: [Double] = []
        for i in weather {
            weatherTemperatureArray.append(i.temp)
        }

        let width = rect.width
        let height = rect.height
        
        // Calculate the x point
        
        let margin = Constants.margin
        let graphWidth = width - margin * 2
        
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacing = graphWidth / CGFloat(weatherTemperatureArray.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        // Calculate the y point
        
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - (98 + 31)
        
        guard let maxValue = weatherTemperatureArray.max() else {
            return
        }
        
        let columnYPoint = { (graphPoint: Double) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - yPoint // Переворот графика
        }
        
        // Отрисовка линии графика
        
        AppColors.sharedInstance.dividerColor.setFill()
        AppColors.sharedInstance.dividerColor.setStroke()
        
        // Задание точек графика
        let graphPath = UIBezierPath()
        
        // Идем на начало линии графика
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(weatherTemperatureArray[0])))
        
        // Добавляем точки для каждого элемента в массиве graphPointsAdd
        // в соответсвующие точки (x, y)
        for i in 1 ..< weatherTemperatureArray.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(weatherTemperatureArray[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        graphPath.lineWidth = 0.5
        
        // Создаем траекторию обрезания для градиента графика
        
        // 1 - Сохраняем состояние контекста (commented out for now)
        context.saveGState()
        
        // 2 - Создаем копию кривой
        guard let clippingPath = graphPath.copy() as? UIBezierPath else {
            return
        }
        
        // 3 - Добавляем линии в скопированную кривую для завершения обрезаемой области
        clippingPath.addLine(to: CGPoint(
                                x: columnXPoint(weatherTemperatureArray.count - 1),
                                y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        // 4 - Добавляем обрезающую кривую в контекст
        clippingPath.addClip()
        
        // 5 - Проверяем обрезающую кривую - Временный код
        
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
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bottomBorder)
        
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
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(weatherTemperatureArray[i]))
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
        
        let precipitationPath = UIBezierPath()
        
        // Идем на начало линии графика
        precipitationPath.move(to: CGPoint(x: 18, y: 116))
        let precipitationPathWidth = width - margin * 2
        let xPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacing = precipitationPathWidth / CGFloat(weatherTemperatureArray.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        let yPoint: CGFloat = 116
        // Добавляем точки для каждого элемента в массиве graphPointsAdd
        // в соответсвующие точки (x, y)
        for i in 1 ..< weather.count {
            let nextPoint = CGPoint(x: xPoint(i), y: yPoint)
            precipitationPath.addLine(to: nextPoint)
        }
        
        AppColors.sharedInstance.accentBlue.setFill()
        AppColors.sharedInstance.accentBlue.setStroke()
        
        precipitationPath.stroke()
        
        
        context.saveGState()
        
        // Draw the circles on top of the graph stroke
        for i in 0 ..< weatherTemperatureArray.count {
            xRectangleArray.append(xPoint(i))
            var point = CGPoint(x: xPoint(i), y: yPoint)
            point.x -= 2
            point.y -= 4
            
            let rectangle = UIBezierPath(rect: CGRect(origin: point, size: CGSize(width: 4, height: 8)))
            AppColors.sharedInstance.accentBlue.setFill()
            AppColors.sharedInstance.accentBlue.setStroke()
            rectangle.fill()
        }
        
        context.saveGState()
        
        let dashesPath = UIBezierPath()
        
        let  p0 = CGPoint(x: Constants.margin, y: Constants.topBorder)
        dashesPath.move(to: p0)
        
        let  p1 = CGPoint(x: Constants.margin, y: Constants.bottomBorder)
        dashesPath.addLine(to: p1)

        let  p2 = CGPoint(x: graphWidth + Constants.margin, y: Constants.bottomBorder)
        dashesPath.addLine(to: p2)
        

        let  dashes: [ CGFloat ] = [ 3.0, 3.0 ]
        dashesPath.setLineDash(dashes, count: dashes.count, phase: 0.0)

        dashesPath.lineWidth = 0.5
        AppColors.sharedInstance.dividerColor.set()
        dashesPath.stroke()
        
        
    }
    
    private func getGraphValuePointY() {
        
    }
    
    private func setupChart() {
        guard let weather = hourlyWeather else { return }
        
        let localData = TimeInterval(timezoneOffset - moscowTimeOffset)
        
        let margin = Constants.margin
        let graphWidth = self.frame.width - margin * 2
        
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacing = graphWidth / CGFloat(weather.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        var weatherTemperatureArray: [Double] = []
        for i in weather {
            weatherTemperatureArray.append(i.temp)
        }
        
        let topBorder = Constants.topBorder

        let graphHeight = self.frame.height - (98 + 31)
        
        guard let maxValue = weatherTemperatureArray.max() else {
            return
        }
        
        let columnYPoint = { (graphPoint: Double) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - yPoint // Переворот графика
        }
        
        for i in 0...weather.count - 1 {
            let hourWeather = weather[i]
            
            if i == 0 {
                let timeLabel = UILabel(frame: CGRect(x: columnXPoint(i) - 2 , y: 128, width: 40, height: 16))
                self.addSubview(timeLabel)
                timeLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                timeLabel.font = UIFont(name: "Rubik-Regular", size: 14)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 0.96
                paragraphStyle.alignment = .left
                let timeInterval = NSDate(timeIntervalSince1970: TimeInterval(hourWeather.dt) + localData)
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh:mm a" : "HH:mm"
                timeLabel.attributedText = NSMutableAttributedString(string: timeFormatter.string(from: timeInterval as Date), attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
                
                let precipitationLabel = UILabel(frame: CGRect(x: columnXPoint(i), y: 88, width: 23, height: 15))
                self.addSubview(precipitationLabel)
                precipitationLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                precipitationLabel.font = UIFont(name: "Rubik-Regular", size: 12)
                paragraphStyle.lineHeightMultiple = 1.05
                paragraphStyle.alignment = .left
                let precipitationValueString = String(format: "%.0f", hourWeather.pop  ?? "0")
                precipitationLabel.attributedText = NSMutableAttributedString(string: precipitationValueString + "%", attributes: [NSAttributedString.Key.kern: 0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
                let precipitationImage = UIImageView(frame: CGRect(x: columnXPoint(i), y: 68, width: 16, height: 16))
                self.addSubview(precipitationImage)
                precipitationImage.image = UIImage(named: "CloudRain")
                
                let temperatureLabel = UILabel(frame: CGRect(x: columnXPoint(i), y: 0, width: 25, height: 14))
                temperatureLabel.center.y = columnYPoint(hourWeather.temp) - 12
                self.addSubview(temperatureLabel)
                temperatureLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                temperatureLabel.font = UIFont(name: "Rubik-Regular", size: 14)
                paragraphStyle.lineHeightMultiple = 0.84
                paragraphStyle.alignment = .left
                let temperatureValueString = String(format: "%.0f", convertTemperature(hourWeather.temp))
                temperatureLabel.attributedText = NSMutableAttributedString(string: temperatureValueString + "º", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
            } else if i == 7 {
                
                let timeLabel = UILabel(frame: CGRect(x: columnXPoint(i) - 24, y: 128, width: 40, height: 16))
                self.addSubview(timeLabel)
                timeLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                timeLabel.font = UIFont(name: "Rubik-Regular", size: 14)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 0.96
                paragraphStyle.alignment = .left
                let timeInterval = NSDate(timeIntervalSince1970: TimeInterval(hourWeather.dt) + localData)
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh:mm a" : "HH:mm"
                timeLabel.attributedText = NSMutableAttributedString(string: timeFormatter.string(from: timeInterval as Date), attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
                
                let precipitationLabel = UILabel(frame: CGRect(x: 0, y: 88, width: 23, height: 15))
                precipitationLabel.center.x = columnXPoint(i) - 2
                self.addSubview(precipitationLabel)
                precipitationLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                precipitationLabel.font = UIFont(name: "Rubik-Regular", size: 12)
                paragraphStyle.lineHeightMultiple = 1.05
                paragraphStyle.alignment = .left
                let precipitationValueString = String(format: "%.0f", hourWeather.pop  ?? "0")
                precipitationLabel.attributedText = NSMutableAttributedString(string: precipitationValueString + "%", attributes: [NSAttributedString.Key.kern: 0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
                let precipitationImage = UIImageView(frame: CGRect(x: 0, y: 68, width: 16, height: 16))
                precipitationImage.center.x = columnXPoint(i) - 2
                self.addSubview(precipitationImage)
                precipitationImage.image = UIImage(named: "CloudRain")
                
                let temperatureLabel = UILabel(frame: CGRect(x: columnXPoint(i) - 12, y: 0, width: 25, height: 14))
                temperatureLabel.center.y = columnYPoint(hourWeather.temp) - 12
                self.addSubview(temperatureLabel)
                temperatureLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                temperatureLabel.font = UIFont(name: "Rubik-Regular", size: 14)
                paragraphStyle.lineHeightMultiple = 0.84
                paragraphStyle.alignment = .left
                let temperatureValueString = String(format: "%.0f", convertTemperature(hourWeather.temp))
                temperatureLabel.attributedText = NSMutableAttributedString(string: temperatureValueString + "º", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
            } else {
                
                let timeLabel = UILabel(frame: CGRect(x: columnXPoint(i) - 13, y: 128, width: 40, height: 16))
                self.addSubview(timeLabel)
                timeLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                timeLabel.font = UIFont(name: "Rubik-Regular", size: 14)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 0.96
                paragraphStyle.alignment = .left
                let timeInterval = NSDate(timeIntervalSince1970: TimeInterval(hourWeather.dt) + localData)
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = UserDefaults.standard.bool(forKey:UserDefaultsKeys.is12TimeFormalChosenBoolKey.rawValue) ? "hh:mm a" : "HH:mm"
                timeLabel.attributedText = NSMutableAttributedString(string: timeFormatter.string(from: timeInterval as Date), attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
                
                let precipitationLabel = UILabel(frame: CGRect(x: 0, y: 88, width: 23, height: 15))
                precipitationLabel.center.x = columnXPoint(i)
                self.addSubview(precipitationLabel)
                precipitationLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                precipitationLabel.font = UIFont(name: "Rubik-Regular", size: 12)
                paragraphStyle.lineHeightMultiple = 1.05
                paragraphStyle.alignment = .center
                let precipitationValueString = String(format: "%.0f", hourWeather.pop  ?? "0")
                precipitationLabel.attributedText = NSMutableAttributedString(string: precipitationValueString + "%", attributes: [NSAttributedString.Key.kern: 0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
                let precipitationImage = UIImageView(frame: CGRect(x: 0, y: 68, width: 16, height: 16))
                precipitationImage.center.x = columnXPoint(i)
                self.addSubview(precipitationImage)
                precipitationImage.image = UIImage(named: "CloudRain")
                
                let temperatureLabel = UILabel(frame: CGRect(x: columnXPoint(i), y: 0, width: 25, height: 14))
                temperatureLabel.center.y = columnYPoint(hourWeather.temp) - 12
                self.addSubview(temperatureLabel)
                temperatureLabel.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
                temperatureLabel.font = UIFont(name: "Rubik-Regular", size: 14)
                paragraphStyle.lineHeightMultiple = 0.84
                paragraphStyle.alignment = .left
                let temperatureValueString = String(format: "%.0f", convertTemperature(hourWeather.temp))
                temperatureLabel.attributedText = NSMutableAttributedString(string: temperatureValueString + "º", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
            }
            
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
    
}

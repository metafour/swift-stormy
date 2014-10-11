//
//  Current.swift
//  Stormy
//
//  Created by Camron Schwoegler on 10/9/14.
//  Copyright (c) 2014 metafour.org. All rights reserved.
//

import Foundation

struct Current {

    var debug: Bool = false
    var currentTime: String?
    var temperature: Int
    var feelsLike: Int
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: String?

    init(weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as NSDictionary
        let currentTimeIntValue = currentWeather["time"] as Int
        let weatherIcon = currentWeather["icon"] as String
        
        temperature = currentWeather["temperature"] as Int
        feelsLike = currentWeather["apparentTemperature"] as Int
        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        icon = iconStringFromIcon(weatherIcon)
        currentTime = dateStringFromUnixTime(currentTimeIntValue)
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func iconStringFromIcon(iconString: String) -> String {
        var weatherIcon: String
        
        if debug {
            println("iconStringFromIcon: iconString: \(iconString)")
        }
        
        
        switch iconString {
        case "clear-day":
            weatherIcon = ""
        case "clear-night":
            weatherIcon = ""
        case "rain":
            weatherIcon = ""
        case "snow":
            weatherIcon = ""
        case "sleet":
            weatherIcon = ""
        case "wind":
            weatherIcon = ""
        case "fog":
            weatherIcon = ""
        case "cloudy":
            weatherIcon = ""
        case "partly-cloudy-day":
            weatherIcon = ""
        case "partly-cloudy-night":
            weatherIcon = ""
        default:
            weatherIcon = ""
        }
        
        return weatherIcon
    }

    
    
    
    
    
    
    
}

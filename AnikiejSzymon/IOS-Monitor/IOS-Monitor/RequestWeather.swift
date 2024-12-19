//
//  RequestWeather.swift
//  IOS-Monitor
//
//  Created by stud on 19/12/2024.
//

final class RequestWeather {
    private init() {}
    
    static func requestWeatherData(mode: Int) -> Dictionary<String, Double> {
        switch mode {
        case 0:
            return [
                "precipitation_value": 0.0,
                "precipitation_type": 0.0,      // 0 - none, 1 - rain, 2 - snow
                "cloudiness": 4.0,
                "temperature": 25.0,
                "pressure": 1000.0,
                "humidity": 13.0,
                "visibility": 100.0,
                "wind_speed": 3.0,
                "wind_direction": 120.0,
                "pm10": 5.3,
                "pm2_5": 1.2,
                "aqi": 7.0,
                "grasses": 0.0,
                "ragweed": 1.0,
                "olive": 1.0,
                "mugwort": 2.0,
                "alder": 0.0,
                "hazel": 3.0,
                "ash": 4.0,
                "birch": 5.0,
                "cottonwood": 6.0,
                "oak": 2.0,
                "pine": 5.0
            ]
        case 1:
            return [
                "precipitation_value": 54.0,
                "precipitation_type": 1.0,      // 0 - none, 1 - rain, 2 - snow
                "cloudiness": 78.0,
                "temperature": 13.0,
                "pressure": 1021.0,
                "humidity": 85.0,
                "visibility": 13.0,
                "wind_speed": 7.0,
                "wind_direction": 300.0,
                "pm10": 12.3,
                "pm2_5": 4.2,
                "aqi": 3.0,
                "grasses": 3.0,
                "ragweed": 5.0,
                "olive": 2.0,
                "mugwort": 0.0,
                "alder": 6.0,
                "hazel": 3.0,
                "ash": 4.0,
                "birch": 5.0,
                "cottonwood": 6.0,
                "oak": 0.0,
                "pine": 0.0
            ]
        case 2:
            return [
                "precipitation_value": 69.0,
                "precipitation_type": 2.0,      // 0 - none, 1 - rain, 2 - snow
                "cloudiness": 97.0,
                "temperature": -4.0,
                "pressure": 998.0,
                "humidity": 85.0,
                "visibility": 13.0,
                "wind_speed": 7.0,
                "wind_direction": 20.0,
                "pm10": 12.3,
                "pm2_5": 4.2,
                "aqi": 6.0,
                "grasses": 3.0,
                "ragweed": 5.0,
                "olive": 2.0,
                "mugwort": 0.0,
                "alder": 6.0,
                "hazel": 3.0,
                "ash": 4.0,
                "birch": 5.0,
                "cottonwood": 6.0,
                "oak": 0.0,
                "pine": 0.0
            ]
        default:
            print("API requests not finished yet, testing data only")
            return [:]
        }
    }
}

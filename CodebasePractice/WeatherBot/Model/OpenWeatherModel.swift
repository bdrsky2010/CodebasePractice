//
//  OpenWeatherModel.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/19/24.
//

import Foundation

struct OpenWeather: Decodable {
    let weather: [Weather]
    let detail: WeatherDetail
    let wind: Wind
    let region: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case detail = "main"
        case wind
        case region = "name"
    }
}

struct Weather: Decodable {
    let type: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case type = "main"
        case description
        case icon
    }
}

struct WeatherDetail: Decodable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case humidity
    }
}

struct Wind: Decodable {
    let speed: Double
    let integerSpeed: Int
    
    enum CodingKeys: CodingKey {
        case speed
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try container.decode(Double.self, forKey: .speed)
        self.integerSpeed = Int(round(speed))
    }
}

enum WeatherCondition: String, CaseIterable {
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case atmosphere = "Atmosphere"
    case clear = "Clear"
    case clouds = "Clouds"
}

//
//  CityModel.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import Foundation

struct CityModel: Decodable {
    let name: String
    let coordinates: Coordinates
    let temperature: TemperatureModel

    enum CodingKeys: String, CodingKey {
        case name
        case coordinates = "coord"
        case temperature = "main"
    }
}

struct Coordinates: Decodable {
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct TemperatureModel: Decodable {
    let current: Double
    let feelsLike: Double
    let min: Double
    let max: Double
    let pressure: Double
    let humidity: Double

    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case feelsLike = "feels_like"
        case min = "temp_min"
        case max = "temp_max"
        case pressure
        case humidity
    }
}

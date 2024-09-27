//
//  ForecastModel.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import Foundation

struct ForecastModel: Decodable {
    let list: [ForecastTemperature]
}

struct ForecastTemperature: Decodable {
    let temperature: DailyForecastTemperature

    enum CodingKeys: String, CodingKey {
        case temperature = "main"
    }
}


struct DailyForecastTemperature: Decodable {
    let day: Double

    enum CodingKeys: String, CodingKey {
        case day = "temp"
    }
}

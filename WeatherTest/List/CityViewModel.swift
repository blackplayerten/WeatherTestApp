//
//  CityViewModel.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//
import UIKit

typealias WeatherInformation = NSAttributedString

final class CityViewModel {
    let nameCity: NSAttributedString
    let coordinates: NSAttributedString
    let temperature: NSAttributedString

    let additionalInfo: [WeatherInformation]

    init(city: CityModel) {
        let nameCity = NSAttributedString(
            string: city.name,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )
        
        func setDefaultAttributes(to: String) -> NSAttributedString {
            NSAttributedString(
                string: to,
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.gray
                ]
            )
        }

        let temperature = NSAttributedString(
            string: convertToCelcii(city.temperature.current),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ]
        )

        let coordinates = setDefaultAttributes(to: "longitude: \(city.coordinates.longitude)\n latitude: \(city.coordinates.latitude)")

        self.nameCity = nameCity
        self.temperature = temperature

        self.coordinates = coordinates

        // Поля, не относящиеся к основной информации
        self.additionalInfo = [
            setDefaultAttributes(to: "Feels like: " + convertToCelcii(city.temperature.feelsLike)),
            setDefaultAttributes(to: "Minimum: " + convertToCelcii(city.temperature.min)),
            setDefaultAttributes(to: "Maximum: " + convertToCelcii(city.temperature.max)),
            setDefaultAttributes(to: "Pressure: " + "\(city.temperature.pressure)")
        ]
    }
}

func convertToCelcii(_ temp: Double) -> String {
    "\(Int(temp - 273.15))°"
}

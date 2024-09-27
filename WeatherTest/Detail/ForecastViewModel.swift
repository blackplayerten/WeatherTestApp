//
//  ForecastViewModel.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import UIKit

final class ForecastViewModel {
    var dayTemperatures: [NSAttributedString]

    init(model: ForecastModel) {
        dayTemperatures = model.list.compactMap {
            NSAttributedString(
                string: "Average: " + convertToCelcii($0.temperature.day),
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray
                ]
            )
        }
    }
}

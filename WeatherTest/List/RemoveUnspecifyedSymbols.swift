//
//  RemoveUnspecifyedSymbols.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import Foundation

@propertyWrapper
struct RemoveUnspecifyedSymbols {
    private(set) var value = ""
    var projectedValue = false

    var wrappedValue: String {
        get {
            return value
        }
        set {
            value = newValue
                .filter { $0.isLetter || $0.isWhitespace }
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: " ")
                .joined(separator: " ")
                .components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")

            projectedValue = value != newValue
        }
    }

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
}

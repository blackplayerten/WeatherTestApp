//
//  ListInteractor.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import Foundation

final class ListInteractor {
    weak var output: InteractorOutput?

    private let service: ServiceCityDescription

    init(service: ServiceCityDescription = ServiceCity.shared) {
        self.service = service
    }
}

extension ListInteractor: InteractorInput {
    func loadCities(names: [String]) {
        let dispatchGroup = DispatchGroup()

        var results = [Result<CityModel, ServiceError>]()

        for name in names {
            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInitiated).async() {
                self.service.loadCity(name: name) { result in
                    results.append(result)
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.global(qos: .userInitiated), execute: {
            DispatchQueue.main.async {
                if results.isEmpty {
                    self.output?.didRecieveError(with: .invalidData)
                    return
                }

                var cities = [CityModel]()

                for result in results {
                    switch result {
                    case .success(let city):
                        cities.append(city)
                    case .failure:
                        continue
                    }
                }

                if cities.isEmpty {
                    self.output?.didRecieveError(with: .invalidData)
                    return
                }

                if cities.count == 1 {
                    self.output?.didFind(with: cities)
                    return
                }

                self.output?.didLoad(with: cities)
            }
        })
    }
}

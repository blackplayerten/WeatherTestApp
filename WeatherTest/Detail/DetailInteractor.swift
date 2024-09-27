//
//  DetailInteractor.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import Foundation

final class DetailInteractor {
    weak var output: DetailInteractorOutput?

    private let service: ServiceCityDescription

    init(service: ServiceCityDescription = ServiceCity.shared) {
        self.service = service
    }
}

extension DetailInteractor: DetailInteractorInput {
    func loadForecast(name: String) {
        service.loadForecast(name: name) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let forecast):
                    self.output?.didLoad(with: forecast)
                case .failure(let error):
                    self.output?.didRecieveError(with: error)
                }
            }
        }
    }
}

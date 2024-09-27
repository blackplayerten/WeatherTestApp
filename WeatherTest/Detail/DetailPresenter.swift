//
//  DetailPresenter.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

final class DetailPresenter {
    weak var view: DetailViewInput?
    weak var moduleInput: DetailInput?

    private let interactor: DetailInteractorInput

    init(interactor: DetailInteractorInput) {
        self.interactor = interactor
    }
}

extension DetailPresenter: DetailViewOutput {
    func didLoadView() {
        guard let input = moduleInput else {
            view?.showError(with: "Can't load city")
            return
        }

        view?.configure(with: input.city, nil)
    }

    var additionalInfo: [WeatherInformation] {
        guard let input = moduleInput else {
            view?.showError(with: "Can't load city")
            return []
        }
        return input.city.additionalInfo
    }

    func didTapForecastButton() {
        guard let input = moduleInput else {
            view?.showError(with: "Can't load city")
            return
        }

        view?.showLoading()
        view?.forecast(hide: true)

        interactor.loadForecast(name: input.city.nameCity.string)
    }
}

extension DetailPresenter: DetailInteractorOutput {
    func didLoad(with model: ForecastModel) {
        view?.hideLoading()
        view?.forecast(hide: false)

        guard let input = moduleInput else {
            view?.showError(with: "Can't load city")
            return
        }
        
        let viewModel = ForecastViewModel(model: model)
        
        view?.configure(with: input.city, viewModel)
    }

    func didRecieveError(with error: ServiceError) {
        view?.hideLoading()
        view?.forecast(hide: true)
        view?.showError(with: error.rawValue)
    }
}

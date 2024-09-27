//
//  DetailProtocols.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

protocol DetailInput: AnyObject {
    var city: CityViewModel { get }
}

protocol DetailViewOutput: AnyObject {
    func didLoadView()
    var additionalInfo: [WeatherInformation] { get }
    func didTapForecastButton()
}

protocol DetailViewInput: AnyObject {
    func showLoading()
    func hideLoading()
    func forecast(hide: Bool)
    func configure(with model: CityViewModel, _ forecast: ForecastViewModel?)
    func showError(with title: String)
}

protocol DetailInteractorInput: AnyObject {
    func loadForecast(name: String)
}

protocol DetailInteractorOutput: AnyObject {
    func didRecieveError(with: ServiceError)
    func didLoad(with model: ForecastModel)
}

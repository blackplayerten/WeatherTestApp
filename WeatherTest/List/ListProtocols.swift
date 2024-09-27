//
//  ListProtocols.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

protocol ListViewInput: AnyObject {
    func configure()
    func showLoading()
    func hideLoading()
    func showTable(is show: Bool)
    func showError(with title: String)
}

protocol ListViewOutput: AnyObject {
    func didLoadView()
    var count: Int { get }
    func item(at index: Int) -> CityViewModel
    func didTapSearchButton(with name: String)
    func didTapShowCityInfo(city: CityViewModel)
}

protocol InteractorInput: AnyObject {
    func loadCities(names: [String])
}

protocol InteractorOutput: AnyObject {
    func didRecieveError(with: ServiceError)
    func didLoad(with models: [CityModel])
    func didFind(with cities: [CityModel])
}

protocol ListRouterInput: AnyObject {
    func openDetail(city: CityViewModel)
}

protocol ListOutput: AnyObject {
    var cityName: String { get }
}

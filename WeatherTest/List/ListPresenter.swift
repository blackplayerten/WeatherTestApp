//
//  ListPresenter.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

final class ListPresenter {
    weak var view: ListViewInput?

    private let interactor: InteractorInput
    private let router: ListRouterInput

    private let defaultCities = ["Moscow", "Saint Petersburg"]
    private var cities: [CityViewModel] = []

    init(interactor: InteractorInput, router: ListRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension ListPresenter: ListViewOutput {
    func didLoadView() {
        view?.showLoading()
        view?.showTable(is: false)

        interactor.loadCities(names: defaultCities)
    }

    var count: Int {
        cities.count
    }

    func item(at index: Int) -> CityViewModel {
        cities[index]
    }

    func didTapSearchButton(with text: String) {
        view?.showLoading()
        view?.showTable(is: false)

        @RemoveUnspecifyedSymbols var cityName = text

        for city in self.cities {
            if city.nameCity.string == cityName {
                view?.showError(with: "The city is already added")
                return
            }
        }

        if cityName.count < 3 {
            view?.showError(with: "The city must contain a minimum of 3 characters")
            return
        }

        interactor.loadCities(names: [cityName])
    }

    func didTapShowCityInfo(city: CityViewModel) {
        router.openDetail(city: city)
    }
}

extension ListPresenter: InteractorOutput {
    func didLoad(with models: [CityModel]) {
        view?.hideLoading()

        let viewModels = models.map { CityViewModel(city: $0) }
        self.cities = viewModels

        view?.showTable(is: true)
        view?.configure()
    }

    func didFind(with cities: [CityModel]) {
        view?.hideLoading()
        view?.showTable(is: true)

        let viewModels = cities.map { CityViewModel(city: $0) }
        self.cities.append(contentsOf: viewModels)
        view?.configure()
    }

    func didRecieveError(with error: ServiceError) {
        view?.hideLoading()
        view?.showError(with: error.rawValue)
    }
}

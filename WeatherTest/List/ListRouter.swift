//
//  ListRouter.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import Foundation

final class ListRouter {
    weak var viewController: ListViewController?
    private weak var cityViewModel: CityViewModel?
}

extension ListRouter: ListRouterInput {
    func openDetail(city: CityViewModel) {
        self.cityViewModel = city

        let context = DetailContext(moduleInput: self)
        if context.moduleInput?.city == nil { return }

        let detailViewController = DetsailAssembler.assembly(with: context)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListRouter: DetailInput {
    var city: CityViewModel {
        self.cityViewModel!
    }
}

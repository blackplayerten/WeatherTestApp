//
//  ListAssembler.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import UIKit

final class ListAssembler {
    static func assembly() -> UIViewController {
        let interactor = ListInteractor()
        let router = ListRouter()
        let presenter = ListPresenter(interactor: interactor, router: router)
        let viewController = ListViewController(output: presenter)

        presenter.view = viewController
        interactor.output = presenter
        router.viewController = viewController

        return viewController
    }

    private init() {}
}


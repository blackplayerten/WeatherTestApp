//
//  DetailContainer.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import UIKit

final class DetsailAssembler {

    static func assembly(with context: DetailContext) -> UIViewController {
        let interactor = DetailInteractor()
        let presenter = DetailPresenter(interactor: interactor)
        let viewController = DetailViewController(output: presenter)

        presenter.view = viewController
        presenter.moduleInput = context.moduleInput
        interactor.output = presenter

        return viewController
    }

    private init() {}
}

struct DetailContext {
    weak var moduleInput: DetailInput?
}

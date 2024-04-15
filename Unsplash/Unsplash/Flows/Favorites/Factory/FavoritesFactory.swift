//
//  FavoritesFactory.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

enum FavoritesFactory {
    
    static func build() -> UIViewController {
        let controller = FavoritesController()
        let dataService: DataKeeperProtocol = Container.shared.coreDataStack
        let presenter = FavoritesPresenter(dataService: dataService)
        controller.presenter = presenter
        presenter.viewController = controller
        return controller
    }
}

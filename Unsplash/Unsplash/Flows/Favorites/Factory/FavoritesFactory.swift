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
        let presenter = FavoritesPresenter()
        controller.presenter = presenter
        presenter.viewController = controller
        return controller
    }
}

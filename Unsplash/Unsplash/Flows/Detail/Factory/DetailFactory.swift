//
//  DetailFactory.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

enum DetailFactory {
    
    static func build(input: ModuleInput?) -> UIViewController {
        guard let input = input as? DetailInput else {
            assertionFailure("Detail module input failure")
            return UIViewController()
        }
        let controller = DetailController()
        let presenter = DetailPresenter(image: input.image)
        controller.presenter = presenter
        presenter.viewController = controller
        return controller
    }
}

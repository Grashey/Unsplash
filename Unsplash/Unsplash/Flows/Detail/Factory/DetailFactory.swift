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
        let dataService: DataKeeperProtocol = Container.shared.coreDataStack
        let presenter = DetailPresenter(model: input.model, dataService: dataService)
        controller.presenter = presenter
        presenter.viewController = controller
        return controller
    }
}

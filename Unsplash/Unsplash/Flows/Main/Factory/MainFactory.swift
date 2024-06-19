//
//  MainFactory.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

enum MainFactory {
    
   static func build() -> UIViewController {
       let controller = MainController()
       let networkService = MainNetworkService()
       let dataService: DataKeeperProtocol = Container.shared.cache
       let presenter = MainPresenter(networkService: networkService, dataService: dataService)
       controller.presenter = presenter
       presenter.viewController = controller
       return controller
    }
}

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
       let presenter = MainPresenter()
       controller.presenter = presenter
       presenter.viewController = controller
       return controller
    }
}

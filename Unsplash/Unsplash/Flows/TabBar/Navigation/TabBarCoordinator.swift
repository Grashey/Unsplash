//
//  TabBarCoordinator.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

final class TabBarCoordinator: iCoordinator {
    
    private var window: UIWindow?
    private var controller: TabBarController
    private lazy var mainCoordinator = MainCoordinator(navigation: controller.mainNavigation)

    init(window: UIWindow?) {
        self.window = window
        self.controller = TabBarController()
    }

    func start() {
        window?.rootViewController = controller
        mainCoordinator.start()
    }
}

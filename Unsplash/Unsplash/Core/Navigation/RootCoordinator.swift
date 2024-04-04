//
//  RootCoordinator.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

protocol iCoordinator {
    func start()
}

final class RootCoordinator: iCoordinator {

    private let window: UIWindow?

    private lazy var tabBarCoordinator = TabBarCoordinator(window: window)

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        tabBarCoordinator.start()
    }

}

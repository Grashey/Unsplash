//
//  RootCoordinator.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

protocol iCoordinator {
    func start(_ moduleInput: ModuleInput?)
}

extension iCoordinator {
    func start(_ moduleInput: ModuleInput? = nil) {
        start(moduleInput)
    }
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

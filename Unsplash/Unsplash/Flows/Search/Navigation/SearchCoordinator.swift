//
//  SearchCoordinator.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

final class SearchCoordinator: iCoordinator {
    
    private var navigation: UINavigationController?
    private let assembly: iAssembly

    init(navigation: UINavigationController?, assembly: iAssembly = Assembly()) {
        self.navigation = navigation
        self.assembly = assembly
    }
    
    func start() {
        guard let controller = assembly.build(.search) as? SearchController else { return }
        navigation?.viewControllers = [controller]
    }
}

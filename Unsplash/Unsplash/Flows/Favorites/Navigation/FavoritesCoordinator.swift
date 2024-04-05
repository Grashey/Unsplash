//
//  FavoritesCoordinator.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

final class FavoritesCoordinator: iCoordinator {
    
    private var navigation: UINavigationController?
    private let assembly: iAssembly
    
    private lazy var detailCoordinator = DetailCoordinator(navigation: navigation, assembly: assembly)

    init(navigation: UINavigationController?, assembly: iAssembly = Assembly()) {
        self.navigation = navigation
        self.assembly = assembly
    }
    
    func start() {
        guard let controller = assembly.build(.favorites) as? FavoritesController else { return }
        navigation?.viewControllers = [controller]
        
        controller.onDetail = { [unowned self] input in
            self.detailCoordinator.start(input)
        }
    }
}

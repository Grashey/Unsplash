//
//  DetailCoordinator.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

final class DetailCoordinator: iCoordinator {
    
    private var navigation: UINavigationController?
    private let assembly: iAssembly

    init(navigation: UINavigationController?, assembly: iAssembly) {
        self.navigation = navigation
        self.assembly = assembly
    }
    
    func start(_ moduleInput: ModuleInput?) {
        guard let controller = assembly.build(.detail, moduleInput: moduleInput) as? DetailController else { return }
        controller.hidesBottomBarWhenPushed = true
        navigation?.pushViewController(controller, animated: true)
    }
}

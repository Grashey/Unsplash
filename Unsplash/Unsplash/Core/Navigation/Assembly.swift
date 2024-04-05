//
//  Assembly.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

protocol iAssembly {
    func build(_ moduleName: ModuleName, moduleInput: ModuleInput?) -> UIViewController
}

extension iAssembly {
    func build(_ moduleName: ModuleName, moduleInput: ModuleInput? = nil) -> UIViewController {
        build(moduleName, moduleInput: moduleInput)
    }
}

final class Assembly: iAssembly {
    
    func build(_ moduleName: ModuleName, moduleInput: ModuleInput?) -> UIViewController {
        switch moduleName {
        case .main: return MainFactory.build()
        }
    }
}

//
//  DIContainer.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import Foundation

class Container {
    static let shared = Container()
    private init() {}

    lazy var coreDataStack = CoreDataStack(modelName: "CoreDataModel")
}

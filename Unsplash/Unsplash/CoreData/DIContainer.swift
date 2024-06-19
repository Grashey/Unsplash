//
//  DIContainer.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import Foundation

enum CoreDataModelName: String {
    case favorites = "Favorites"
    case cache = "Cache"
}

class Container {
    
    static let shared = Container()
    private init() {}

    lazy var favorites = CoreDataStack(modelName: CoreDataModelName.favorites)
    lazy var cache = CoreDataStack(modelName: CoreDataModelName.cache)
}

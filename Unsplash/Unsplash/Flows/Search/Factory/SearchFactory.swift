//
//  SearchAssembly.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

enum SearchFactory {
    
   static func build() -> UIViewController {
        let controller = SearchController()
        return controller
    }
}

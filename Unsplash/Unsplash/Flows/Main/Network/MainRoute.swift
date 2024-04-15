//
//  MainRoute.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 06.04.2024.
//

import Foundation

enum MainRoute {
    case photos
    case search
    case load
}

extension MainRoute: Route {
    
    var method: String { "GET" }
    var baseURL: String { Api.baseUrl }

    var url: String {
        switch self {
        case .photos:
            return Api.photos
        case .search:
            return Api.search
        case .load:
            return ""
        }
    }
    
}

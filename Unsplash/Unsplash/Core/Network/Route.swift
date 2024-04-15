//
//  Route.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 06.04.2024.
//

import Foundation

protocol Route {

    var method: String { get }
    var url: String { get }
    var baseURL: String { get }
    
    func makeURL(_ path: String?) -> String
}

extension Route {

    func makeURL(_ path: String? = nil) -> String {
        guard let path = path else {
            return baseURL.appending(url)
        }
        return path
    }
}

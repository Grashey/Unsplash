//
//  CoreNetworkError.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 06.04.2024.
//

import Foundation

enum CoreNetworkError: Error {
    case client
    case server
    case response
    case data
    case wrongUrl
    case decodable
    case unknown

    var message: String {
        switch self {
        case .client:
            return "client error"
        case .server:
            return "server error"
        case .response:
            return "no response received"
        case .data:
            return "data error"
        case .wrongUrl:
            return "wrong url"
        case .decodable:
            return "decode error"
        case .unknown:
            return "unknown error"
        }
    }
}

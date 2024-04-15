//
//  RequestBuilder.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 06.04.2024.
//

import Foundation

fileprivate enum ApiKey {
    static let value = "24R0JBq9tJ-IiHZD3Siv3nVy1H0mpOPGwi6EYUuu4Uw"
}

protocol iRequestBuilder {
    func makeRequest(route: Route, parameters: [String: Any]?, path: String?) -> URLRequest
}

extension iRequestBuilder {
    
    func makeRequest(route: Route, parameters: [String: Any]? = nil, path: String? = nil) -> URLRequest {
        makeRequest(route: route, parameters: parameters, path: path)
    }
}

final class RequestBuilder: iRequestBuilder {

    func makeRequest(route: Route, parameters: [String: Any]? = nil, path: String? = nil) -> URLRequest {
        var components = URLComponents(string: route.makeURL(path))
        
        if let parameters = parameters {
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        let url = components?.url
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = route.method
        
        if path == nil {
            request.setValue("Client-ID \(ApiKey.value)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

}

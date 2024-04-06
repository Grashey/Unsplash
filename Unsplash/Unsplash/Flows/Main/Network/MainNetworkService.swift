//
//  MainNetworkService.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 06.04.2024.
//

import Foundation

protocol iMainNetworkService {
    func fetchPhotos(page: Int) async throws -> Data
    func searchPhotos(value: String, page: Int) async throws -> Data
    func loadPhoto(url: String) async throws -> Data
}

final class MainNetworkService: iMainNetworkService {
    
    private let httpClient: iHTTPClient
    private let requestBuilder: iRequestBuilder
    
    init(httpClient: iHTTPClient = HTTPClient(), requestBuilder: iRequestBuilder = RequestBuilder()) {
        self.httpClient = httpClient
        self.requestBuilder = requestBuilder
    }
    
    func fetchPhotos(page: Int) async throws -> Data {
        let parameters = ["page": String(page),
                          "per_page": "20"]
        let request = requestBuilder.makeRequest(route: MainRoute.photos, parameters: parameters)
        let response = try await httpClient.send(request: request)
        return response.data
    }
    
    func searchPhotos(value: String, page: Int) async throws -> Data {
        let parameters = ["query": value,
                          "page": String(page),
                          "per_page": "20"]
        let request = requestBuilder.makeRequest(route: MainRoute.search, parameters: parameters)
        let response = try await httpClient.send(request: request)
        return response.data
    }
    
    func loadPhoto(url: String) async throws -> Data {
        let request = requestBuilder.makeRequest(route: MainRoute.load, path: url)
        let response = try await httpClient.send(request: request)
        return response.data
    }
    
}

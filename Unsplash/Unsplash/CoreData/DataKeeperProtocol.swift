//
//  DataKeeperProtocol.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import Foundation

protocol DataKeeperProtocol {
    func check(id: String) -> Bool
    func deleteAll()
    func delete(id: String)
    func addEntity(id: String, name: String, author: String, date: String, imageData: Data)
}

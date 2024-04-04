//
//  SearchPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import Foundation

protocol iSearchPresenter {
   
    func clear()
    func search(_ text: String)
}

final class SearchPresenter: iSearchPresenter {
    
    weak var viewController: SearchController?
    
    func clear() {
        print("clear")
    }
    
    func search(_ text: String) {
        print("searching \(text)")
    }
}

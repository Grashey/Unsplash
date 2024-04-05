//
//  SearchPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

protocol iSearchPresenter {
   
    var viewModels: [SearchViewModel] {get set}
    
    func clearSearch()
    func findImagesWith(_ text: String)
    
    func fetchData()
}

final class SearchPresenter: iSearchPresenter {
    
    weak var viewController: SearchController?
    
    var viewModels: [SearchViewModel] = []
    
    func clearSearch() {
        print("clear")
    }
    
    func findImagesWith(_ text: String) {
        print("searching \(text)")
    }
    
    func fetchData() {
        let images = [UIImage(named: "pic1"), UIImage(named: "pic2"), UIImage(named: "pic3")]
        
        for _ in .zero..<20 {
            let picIndex = Int.random(in: .zero...2)
            let image = images[picIndex]
            let model = SearchViewModel(image: image)
            viewModels.append(model)
        }
        
        viewController?.reloadView()
    }
    
    
}

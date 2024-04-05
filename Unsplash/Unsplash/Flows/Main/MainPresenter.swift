//
//  MainPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

protocol iMainPresenter {
   
    var viewModels: [MainViewModel] {get set}
    
    func clearSearch()
    func findImagesWith(_ text: String)
    func fetchData()
    func prepareDetailInputFor(_ index: Int) -> DetailInput
}

final class MainPresenter: iMainPresenter {
    
    weak var viewController: MainController?
    var viewModels: [MainViewModel] = []
    
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
            let model = MainViewModel(image: image)
            viewModels.append(model)
        }
        viewController?.reloadView()
    }
    
    func prepareDetailInputFor(_ index: Int) -> DetailInput {
        let image = viewModels[index].image
        return DetailInput(image: image)
    }
    
}

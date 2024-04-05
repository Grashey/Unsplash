//
//  FavoritesPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

protocol iFavoritesPresenter {
    var viewModels: [FavoritesViewModel] {get set}
    
    func fetchData()
    func prepareDetailInputFor(_ index: Int) -> DetailInput
    func refresh()
}

final class FavoritesPresenter: iFavoritesPresenter {
    
    weak var viewController: FavoritesController?
    var viewModels: [FavoritesViewModel] = []
    private var pageNumber: Int = .zero
    
    func refresh() {
        pageNumber = .zero
        viewModels.removeAll()
    }
    
    func fetchData() {
        let page = makePage()
        viewModels += page
        pageNumber += 1
        viewController?.reloadView()
    }
    
    private func makePage() -> [FavoritesViewModel] {
        let images = [UIImage(named: "pic1"), UIImage(named: "pic2"), UIImage(named: "pic3")]
        var array = [FavoritesViewModel]()
        
        for _ in .zero..<20 {
            let picIndex = Int.random(in: .zero...2)
            let image = images[picIndex]
            let model = FavoritesViewModel(image: image)
            array.append(model)
        }
        return array
    }
    
    func prepareDetailInputFor(_ index: Int) -> DetailInput {
        let image = viewModels[index].image
        return DetailInput(image: image)
    }
}

//
//  DetailPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

protocol iDetailPresenter {
    func makeModel() -> UIImage?
    func operateFavorites()
    func checkIsFavorite() -> Bool
}

final class DetailPresenter: iDetailPresenter {
    
    weak var viewController: DetailController?
    
    private let image: UIImage?
    private var isFavorite: Bool = false {
        didSet {
            guard oldValue != isFavorite else { return }
            viewController?.switchFavoriteButtonImage()
        }
    }
    
    init(image: UIImage?) {
        self.image = image
    }
    
    func makeModel() -> UIImage? {
        image
    }
    
    func operateFavorites() {
        isFavorite.toggle()
    }
    
    func checkIsFavorite() -> Bool {
        isFavorite
    }
}

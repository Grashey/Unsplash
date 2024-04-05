//
//  DetailPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

protocol iDetailPresenter {
    func makeModel() -> DetailViewModel
    func operateFavorites()
    func checkIsFavorite() -> Bool
}

final class DetailPresenter: iDetailPresenter {
    
    weak var viewController: DetailController?
    
    private let model: DetailViewModel
    private var isFavorite: Bool = false {
        didSet {
            guard oldValue != isFavorite else { return }
            viewController?.switchFavoriteButtonImage()
        }
    }
    
    private let formatter: DateFormatter = {
        $0.dateFormat = "dd.MM.yyyy"
        return $0
    }(DateFormatter())
    
    init(image: UIImage?) {
        let date = Date()
        self.model = DetailViewModel(image: image, author: "Vincent van Gogh", date: formatter.string(from: date))
    }
    
    func makeModel() -> DetailViewModel {
        model
    }
    
    func operateFavorites() {
        isFavorite.toggle()
    }
    
    func checkIsFavorite() -> Bool {
        isFavorite
    }
}

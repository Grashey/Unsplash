//
//  DetailPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

protocol iDetailPresenter {
    func makeModel() -> UIImage?
}

final class DetailPresenter: iDetailPresenter {
    
    weak var viewController: DetailController?
    
    private let image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
    }
    
    func makeModel() -> UIImage? {
        image
    }
}

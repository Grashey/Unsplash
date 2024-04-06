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
    func checkIsFavorite()
    func getIsFavorite() -> Bool
}

final class DetailPresenter: iDetailPresenter {
    
    weak var viewController: DetailController?
    
    private let dataService: DataKeeperProtocol
    private let model: DetailViewModel
    private var dataModel: PhotoDetailDataModel
    private var isFavorite: Bool = false {
        didSet {
            guard oldValue != isFavorite else { return }
            viewController?.switchFavoriteButtonImage()
        }
    }
    
    init(model: PhotoDetailDataModel, dataService: DataKeeperProtocol) {
        self.dataService = dataService
        dataModel = model
        self.model = DetailViewModel(image: dataModel.image, name: dataModel.name, author: dataModel.author, date: dataModel.date)
    }
    
    func makeModel() -> DetailViewModel {
        model
    }
    
    func operateFavorites() {
        if !isFavorite {
            guard let imageData = dataModel.image.pngData() else { return }
            dataService.addEntity(id: dataModel.id, name: dataModel.name, author: dataModel.author, date: dataModel.date, imageData: imageData)
            isFavorite = true
        } else {
            dataService.delete(id: dataModel.id)
            isFavorite = false
        }
    }
    
    func checkIsFavorite() {
        isFavorite = dataService.check(id: dataModel.id)
    }
    
    func getIsFavorite() -> Bool {
        isFavorite
    }
    
}

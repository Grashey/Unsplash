//
//  MainPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit
import SwiftyJSON

protocol iMainPresenter {
   
    var viewModels: [MainViewModel] {get set}
    var isLoading: Bool { get set }
    
    func clearSearch()
    func findImagesWith(_ text: String)
    func fetchData()
    func prepareModelFor(_ index: Int) -> PhotoDetailDataModel
    func refresh()
}

final class MainPresenter: iMainPresenter {
    
    weak var viewController: MainController?
    private let networkService: iMainNetworkService
    var viewModels: [MainViewModel] = []
    private var pageNumber: Int = 1
    private var photos: [PhotoDataModel] = []
    private var searchText: String?

    var isLoading: Bool = false {
        didSet {
            viewController?.isLoading = isLoading
        }
    }
    
    init(networkService: iMainNetworkService) {
        self.networkService = networkService
    }
    
    func clearSearch() {
        searchText = nil
        refresh()
        fetchData()
    }
    
    func findImagesWith(_ text: String) {
        if searchText != text {
            searchText = text
            refresh()
            fetchData()
        }
    }
    
    func refresh() {
        pageNumber = 1
        photos.removeAll()
        viewModels.removeAll()
        viewController?.reloadView()
    }
    
    func fetchData() {
        isLoading = true
        Task {
            do {
                let json = try await makeJSON(searchText)
                let photoModels = json.map { PhotoDataModel($0) }
                let urlStrings = photoModels.map { $0.imageString }
                var images: [UIImage] = []
                for url in urlStrings {
                    let imageData = try await networkService.loadPhoto(url: url)
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
                photos += photoModels
                viewModels += images.map({ MainViewModel(image: $0)})
                await viewController?.showEmptyMessage(isEmpty: photos.isEmpty)
                await viewController?.reloadView()
                pageNumber += 1
                isLoading = false
            } catch(let error) {
                await viewController?.showAlert(error.localizedDescription)
                isLoading = false
            }
        }
    }
    
    func prepareModelFor(_ index: Int) -> PhotoDetailDataModel {
        let image = viewModels[index].image
        let data = photos[index]
        let model = PhotoDetailDataModel(id: data.id, name: data.name, author: data.author, date: data.date, image: image)
        return model
    }
    
    private func makeJSON(_ text: String?) async throws -> [JSON] {
        if let text = text {
            let data = try await networkService.searchPhotos(value: text, page: pageNumber)
            let dict = try JSON(data: data).dictionaryValue
            let json = dict["results"]!.arrayValue
            return json
        } else {
            let data = try await networkService.fetchPhotos(page: pageNumber)
            let json = try JSON(data: data).arrayValue
            return json
        }
    }
    
}

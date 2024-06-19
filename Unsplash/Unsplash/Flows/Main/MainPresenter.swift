//
//  MainPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit
import SwiftyJSON
import CoreData

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
    private let dataService: DataKeeperProtocol
    var viewModels: [MainViewModel] = []
    private var pageNumber: Int = 1
    private var totalPages: Int?
    private var photos: [PhotoDataModel] = []
    private var searchText: String?

    var isLoading: Bool = false {
        didSet {
            viewController?.isLoading = isLoading
        }
    }
    
    private lazy var frc: NSFetchedResultsController<CoreDataEntity> = {
        let request = NSFetchRequest<CoreDataEntity>(entityName: "CoreDataEntity")
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: (dataService as! CoreDataStack).mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return frc
    }()
    
    init(networkService: iMainNetworkService, dataService: DataKeeperProtocol) {
        self.networkService = networkService
        self.dataService = dataService
        try? frc.performFetch()
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
        totalPages = nil
        photos.removeAll()
        viewModels.removeAll()
        viewController?.reloadView()
    }
    
    func fetchData() {
        if let totalPages = totalPages {
            guard totalPages >= pageNumber else { return }
        }
        isLoading = true
        
        Task {
            do {
                let json = try await makeJSON(searchText)
                let photoModels = json.map { PhotoDataModel($0) }
                let images: [UIImage] = Array(repeating: UIImage(), count: photoModels.count)
                photos += photoModels
                viewModels += images.map({ MainViewModel(image: $0)})
                await viewController?.showEmptyMessage(isEmpty: photos.isEmpty)
                await viewController?.reloadView()
                pageNumber += 1
                isLoading = false
                
                for (index,model) in photoModels.enumerated() {
                    let cachedData = checkPhoto(id: model.id)
                    let imageData = cachedData != nil ? cachedData! : try await loadAndCachePhoto(model: model)
                    let photoIndex = photos.isEmpty ? index : photos.count - photoModels.count + index
                    guard viewModels.count >= photoIndex else { return }
                    if let image = UIImage(data: imageData) {
                        viewModels[photoIndex] = MainViewModel(image: image)
                        await viewController?.reloadCellAt(index: photoIndex)
                    }
                }
                
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
            totalPages = dict["total_pages"]?.intValue
            return json
        } else {
            let data = try await networkService.fetchPhotos(page: pageNumber)
            let json = try JSON(data: data).arrayValue
            return json
        }
    }
    
    private func checkPhoto(id: String) -> Data? {
        return dataService.check(id: id) ? frc.fetchedObjects?.filter({$0.id == id}).first?.image : nil
    }
    
    private func loadAndCachePhoto(model: PhotoDataModel) async throws -> Data {
        let imageData = try await networkService.loadPhoto(url: model.imageString)
        dataService.addEntity(id: model.id, name: model.name, author: model.author, date: model.date, imageData: imageData)
        return imageData
    }
    
}

//
//  FavoritesPresenter.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit
import CoreData

protocol iFavoritesPresenter {
    var viewModels: [FavoritesViewModel] {get set}
    
    func prepareModelFor(_ index: Int) -> PhotoDetailDataModel?
    func getData()
    func removeAll()
}

final class FavoritesPresenter: iFavoritesPresenter {
    
    weak var viewController: FavoritesController?
    
    var viewModels: [FavoritesViewModel] = []
    private let dataService: DataKeeperProtocol
    
    init(dataService: DataKeeperProtocol) {
        self.dataService = dataService
    }

    private lazy var frc: NSFetchedResultsController<CoreDataEntity> = {
        let request = NSFetchRequest<CoreDataEntity>(entityName: "CoreDataEntity")
        request.sortDescriptors = [.init(key: "date", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: (dataService as! CoreDataStack).mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = viewController
        return frc
    }()

    func getData() {
        try? frc.performFetch()
        makeModels()
    }

    private func makeModels() {
        guard let objects = frc.fetchedObjects else { return }
        let models = objects.map { FavoritesViewModel(image: UIImage(data: $0.image ?? Data()) ?? UIImage())}
        viewModels = models
    }

    func removeAll() {
        dataService.deleteAll()
    }
   
    func prepareModelFor(_ index: Int) -> PhotoDetailDataModel? {
        guard let objects = frc.fetchedObjects else { return nil }
        let data = objects[index]
        let model = PhotoDetailDataModel(id: data.id ?? "", name: data.name ?? "", author: data.author ?? "", date: data.date ?? "", image: UIImage(data: data.image ?? Data()) ?? UIImage())
        return model
    }

}

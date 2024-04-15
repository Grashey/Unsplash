//
//  CoreDataStack.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import Foundation
import CoreData

class CoreDataStack: DataKeeperProtocol {

    private let container: NSPersistentContainer

    let mainContext: NSManagedObjectContext
    lazy var backgroundContext: NSManagedObjectContext = container.newBackgroundContext()
    var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
    let fetchRequest = NSFetchRequest<CoreDataEntity>(entityName: "CoreDataEntity")

    init(modelName: String) {
        let container = NSPersistentContainer(name: modelName)
        self.container = container

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let url = URL(fileURLWithPath: documentsPath).appendingPathComponent("CoreDataEntity.sqlite")

        do {
            try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                              configurationName: nil,
                                              at: url,
                                              options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                        NSInferMappingModelAutomaticallyOption: true])
        } catch {
            print(error)
            fatalError()
        }

        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.persistentStoreCoordinator = coordinator

        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.persistentStoreCoordinator = coordinator

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextDidChange(notification:)),
                                               name: Notification.Name.NSManagedObjectContextDidSave,
                                               object: self.backgroundContext)
    }

    func check(id: String) -> Bool {
        fetchRequest.predicate = .init(format: "id == '\(id)'")
        var favorites = [CoreDataEntity]()
        backgroundContext.performAndWait {
            let result = try? fetchRequest.execute()
            if let result = result {
                favorites = result
            }
        }
        let entityExists = !favorites.isEmpty
        return entityExists
    }

    func deleteAll() {
        fetchRequest.predicate = nil
        backgroundContext.performAndWait {
            let favorites = try? fetchRequest.execute()
            favorites?.forEach {
                backgroundContext.delete($0)
            }
            try? backgroundContext.save()
        }
    }

    func delete(id: String) {
        fetchRequest.predicate = .init(format: "id == '\(id)'")
        backgroundContext.performAndWait {
            if let objectToDelete = try? fetchRequest.execute().first {
                backgroundContext.delete(objectToDelete)
            }
            try? backgroundContext.save()
        }
    }
    func addEntity(id: String, name: String, author: String, date: String, imageData: Data) {
        mainContext.performAndWait {
            let entity = CoreDataEntity(context: mainContext)
            entity.id = id
            entity.name = name
            entity.author = author
            entity.date = date
            entity.image = imageData
            try? mainContext.save()
        }
    }

}

extension CoreDataStack {
    @objc func contextDidChange(notification: Notification) {
        coordinator.performAndWait {
            mainContext.performAndWait {
                mainContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
}

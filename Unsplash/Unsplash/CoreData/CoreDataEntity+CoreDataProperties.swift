//
//  CoreDataEntity+CoreDataProperties.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import Foundation
import CoreData

extension CoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataEntity> {
        return NSFetchRequest<CoreDataEntity>(entityName: "CoreDataEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var author: String?
    @NSManaged public var date: Date?
    @NSManaged public var image: Data?
}

extension CoreDataEntity: Identifiable {}

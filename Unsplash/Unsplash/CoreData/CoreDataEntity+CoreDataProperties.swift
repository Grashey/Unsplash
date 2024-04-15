//
//  CoreDataEntity+CoreDataProperties.swift
//  
//
//  Created by Aleksandr Fetisov on 06.04.2024.
//
//

import Foundation
import CoreData


extension CoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataEntity> {
        return NSFetchRequest<CoreDataEntity>(entityName: "CoreDataEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?

}

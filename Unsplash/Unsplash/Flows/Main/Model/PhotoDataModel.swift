//
//  PhotoDataModel.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 07.04.2024.
//

import Foundation
import SwiftyJSON

struct PhotoDataModel {
    
    var id: String
    var name: String
    var author: String
    var date: String
    var imageString: String
    
    init (_ json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["alt_description"].stringValue
        self.author = json["user"]["name"].stringValue
        self.date = json["created_at"].stringValue
        self.imageString = json["urls"]["small"].stringValue
    }
}

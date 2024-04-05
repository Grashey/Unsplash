//
//  NotificationName + Ext.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import Foundation

extension Notification.Name {
    static var favoritesUpdatePending: Notification.Name {
        return .init(rawValue: "favoritesUpdatePending")
    }
}

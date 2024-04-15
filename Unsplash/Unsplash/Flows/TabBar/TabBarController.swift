//
//  TabBarController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {

    let mainNavigation = UINavigationController()
    let favoritesNavigation = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainNavigation.tabBarItem = UITabBarItem(title: Constant.FlowTitle.main, image: nil, selectedImage: nil)
        favoritesNavigation.tabBarItem = UITabBarItem(title: Constant.FlowTitle.favorites, image: nil, selectedImage: nil)

        viewControllers = [mainNavigation, favoritesNavigation]
        tabBar.backgroundColor = .systemGray6
    }

}

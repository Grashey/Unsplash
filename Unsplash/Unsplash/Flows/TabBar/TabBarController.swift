//
//  TabBarController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {

    let searchNavigation = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchNavigation.tabBarItem = UITabBarItem(title: Constant.FlowTitle.search, image: nil, selectedImage: nil)

        viewControllers = [searchNavigation]
        tabBar.backgroundColor = .systemGray6
    }

}

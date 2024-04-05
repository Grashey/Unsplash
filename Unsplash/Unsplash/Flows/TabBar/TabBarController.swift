//
//  TabBarController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {

    let mainNavigation = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainNavigation.tabBarItem = UITabBarItem(title: Constant.FlowTitle.main, image: nil, selectedImage: nil)

        viewControllers = [mainNavigation]
        tabBar.backgroundColor = .systemGray6
    }

}

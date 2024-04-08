//
//  SearchBarController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

class SearchBarController: UIViewController {
    
    lazy var searchController: UISearchController = {
        $0.searchBar.searchBarStyle = .prominent
        $0.searchBar.placeholder = Constant.Title.searchPlaceholder
        $0.searchBar.sizeToFit()
        $0.obscuresBackgroundDuringPresentation = false
        return $0
    }(UISearchController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
    }
    
}

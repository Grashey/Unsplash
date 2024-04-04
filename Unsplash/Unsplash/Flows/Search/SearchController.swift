//
//  SearchController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

final class SearchController: SearchBarController {
    
    var presenter: iSearchPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
}

extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter?.clear()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.clear()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}

extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let requiredCharsCount: Int = 2
        guard let text = searchController.searchBar.searchTextField.text, text.count >= requiredCharsCount else { return }
        presenter?.search(text)
    }
}

extension SearchController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

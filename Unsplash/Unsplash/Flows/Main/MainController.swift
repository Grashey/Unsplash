//
//  MainController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 04.04.2024.
//

import UIKit

final class MainController: SearchBarController {
    
    var presenter: iMainPresenter?
    
    private let refreshControl = UIRefreshControl()
    private lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let inset: CGFloat = 16
    
    var onDetail: ((DetailInput) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = MainString.Title.main
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        setupCollectionView()
        presenter?.fetchData()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.description())
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: .zero, left: inset, bottom: .zero, right: inset)
        view.addSubview(collectionView)
    }
    
    private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
    
    func reloadView() {
        collectionView.reloadData()
    }
    
    @objc private func refresh() {
        presenter?.refresh()
        presenter?.fetchData()
        refreshControl.endRefreshing()
    }

}

extension MainController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter?.clearSearch()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.clearSearch()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}

extension MainController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let requiredCharsCount: Int = 2
        guard let text = searchController.searchBar.searchTextField.text, text.count >= requiredCharsCount else { return }
        presenter?.findImagesWith(text)
    }
}

extension MainController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

extension MainController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.viewModels.count ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.description(), for: indexPath)
        if let model = presenter?.viewModels[indexPath.item] {
            (cell as? PhotoCell)?.configureWith(image: model.image)
        }
        return cell
    }
}

extension MainController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailInput = presenter?.prepareDetailInputFor(indexPath.item) {
            onDetail?(detailInput)
        }
        dismissKeyboard()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = presenter?.viewModels.count else { return }
        if indexPath.item == count - 3 {
            presenter?.fetchData()
        }
    }
}

extension MainController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        let cellsInRowCount: Float = 3
        let overalLineSpacing = flowLayout.minimumLineSpacing * CGFloat(cellsInRowCount)
        let cellWidth = CGFloat(roundf(Float((collectionView.visibleSize.width - overalLineSpacing - inset*2))/cellsInRowCount))
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        return cellSize
    }
}

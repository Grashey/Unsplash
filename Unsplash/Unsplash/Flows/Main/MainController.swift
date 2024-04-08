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
    private let cellsInRowCount: Float = 2
    private let inset: CGFloat = 16
    
    var onDetail: ((PhotoDetailDataModel) -> Void)?
    
    private let spinner = SpinnerController()
    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }
            showSpinner(isShown: isLoading)
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.view.frame = view.frame
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
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
    
    private func showSpinner(isShown: Bool) {
        DispatchQueue.main.async { [unowned self] in
            if isShown {
                addChild(spinner)
                view.addSubview(spinner.view)
                spinner.didMove(toParent: self)
            } else {
                spinner.willMove(toParent: nil)
                spinner.view.removeFromSuperview()
                spinner.removeFromParent()
            }
        }
    }
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.searchController.searchBar.resignFirstResponder()
        })
        present(alert, animated: true, completion: nil)
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
        if let model = presenter?.prepareModelFor(indexPath.item) {
            onDetail?(model)
        }
        dismissKeyboard()
    }
}
    
extension MainController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let count = presenter?.viewModels.count,
              let isLoading = presenter?.isLoading,
              let maxSection = indexPaths.map({ $0.row }).max() else { return }
        if maxSection > count - 3, !isLoading {
            presenter?.fetchData()
        }
    }
}

extension MainController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        let overalLineSpacing = flowLayout.minimumLineSpacing * CGFloat(cellsInRowCount)
        let cellWidth = CGFloat(roundf(Float((collectionView.visibleSize.width - overalLineSpacing - inset*2))/cellsInRowCount))
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        return cellSize
    }
}

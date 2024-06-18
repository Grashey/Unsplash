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
    
    private lazy var infoLabel: UILabel = {
        $0.text = MainString.Title.noResults
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = MainString.Title.main
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        addSubviews()
        presenter?.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.view.frame = view.frame
    }
    
    private func addSubviews() {
        setupCollectionView()
        setupLabel()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.description())
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: .zero, left: inset, bottom: .zero, right: inset)
        view.addSubview(collectionView)
    }
    
    private func setupLabel() {
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.size.height/4)
        ])
    }
    
    private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
    
    func reloadView() {
        collectionView.reloadData()
    }
    
    func reloadCellAt(index: Int) {
        collectionView.reloadItems(at: [IndexPath(item: index, section: .zero)])
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
    
    func showEmptyMessage(isEmpty: Bool) {
        infoLabel.isHidden = !isEmpty
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            guard text == searchController.searchBar.searchTextField.text else { return }
            self.presenter?.findImagesWith(text)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = presenter?.viewModels.count,
              let isLoading = presenter?.isLoading else { return }
        if indexPath.item > count - 2, !isLoading {
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

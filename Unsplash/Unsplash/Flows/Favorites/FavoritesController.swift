//
//  FavoritesController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

final class FavoritesController: UIViewController {
 
    var presenter: iFavoritesPresenter?
    
    private let refreshControl = UIRefreshControl()
    private lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let cellsInRowCount: Float = 2
    private let inset: CGFloat = 16
    
    var onDetail: ((DetailInput) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = FavoritesString.Title.main
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        setupCollectionView()
        presenter?.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let pending = presenter?.checkUpdateNeeded(), pending {
            presenter?.refresh()
            presenter?.fetchData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.description())
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: .zero, left: inset, bottom: .zero, right: inset)
        view.addSubview(collectionView)
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

extension FavoritesController: UICollectionViewDataSource {

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

extension FavoritesController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailInput = presenter?.prepareDetailInputFor(indexPath.item) {
            onDetail?(detailInput)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = presenter?.viewModels.count else { return }
        if indexPath.item == count - 1 {
            presenter?.fetchData()
        }
    }
}

extension FavoritesController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        let overalLineSpacing = flowLayout.minimumLineSpacing * CGFloat(cellsInRowCount)
        let cellWidth = CGFloat(roundf(Float((collectionView.visibleSize.width - overalLineSpacing - inset*2))/cellsInRowCount))
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        return cellSize
    }
}

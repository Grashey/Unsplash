//
//  FavoritesController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit
import CoreData

final class FavoritesController: UIViewController {
 
    var presenter: iFavoritesPresenter?
    
    private lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let cellsInRowCount: Float = 3
    private let inset: CGFloat = 16
    
    var onDetail: ((PhotoDetailDataModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = FavoritesString.Title.main
        
        setupCollectionView()
        presenter?.getData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: FavoritesString.Title.remove, style: .plain, target: self, action: #selector(removeAll))
        switchButton()
    }
    
    @objc private func removeAll() {
        presenter?.removeAll()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.description())
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: .zero, left: inset, bottom: .zero, right: inset)
        view.addSubview(collectionView)
    }
    
    private func switchButton() {
        guard let isEmpty = presenter?.viewModels.isEmpty else { return }
        navigationItem.rightBarButtonItem?.isEnabled = !isEmpty
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
        if let model = presenter?.prepareModelFor(indexPath.item) {
            onDetail?(model)
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

extension FavoritesController: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        presenter?.getData()
        switchButton()
        collectionView.reloadData()
    }
}

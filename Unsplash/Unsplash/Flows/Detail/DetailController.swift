//
//  DetailController.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

final class DetailController: UIViewController {
    
    var presenter: iDetailPresenter?
    
    private lazy var detailView = DetailView()
    
    private lazy var favoriteButton: UIButton = {
        $0.frame = CGRect(x: .zero, y: .zero, width: 30, height: 30)
        $0.addTarget(self, action: #selector(operateFavorites), for: .touchUpInside)
        return $0
    }(UIButton())
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detail"
        makeFavoritesButton()
        if let model = presenter?.makeModel() {
            detailView.configureWith(model: model)
        }
    }
    
    private func makeFavoritesButton() {
        let view = UIView(frame: favoriteButton.frame)
        view.addSubview(favoriteButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
        switchFavoriteButtonImage()
    }

    @objc private func operateFavorites() {
        presenter?.operateFavorites()
    }

    func switchFavoriteButtonImage() {
        if let isFavorite = presenter?.checkIsFavorite() {
            if isFavorite {
                favoriteButton.setImage(UIImage(named: DetailString.Image.like), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: DetailString.Image.unlike)?.withTintColor(.black), for: .normal)
            }
        }
    }
    
}

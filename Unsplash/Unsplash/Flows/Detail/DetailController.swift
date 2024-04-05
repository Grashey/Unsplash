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
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detail"
        let image = presenter?.makeModel()
        detailView.configureWith(image: image)
    }
}

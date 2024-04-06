//
//  DetailView.swift
//  Unsplash
//
//  Created by Aleksandr Fetisov on 05.04.2024.
//

import UIKit

final class DetailView: UIView {
    
    private let fontSize: CGFloat = 16
    private let spacing: CGFloat = 8
    
    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var nameLabel: UILabel = {
        $0.text = DetailString.Title.name
        $0.font = .systemFont(ofSize: fontSize, weight: .medium)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        return $0
    }(UILabel())
    
    private lazy var nameValueLabel: UILabel = {
        $0.numberOfLines = .zero
        $0.font = .systemFont(ofSize: fontSize, weight: .regular)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        return $0
    }(UILabel())
    
    private lazy var authorLabel: UILabel = {
        $0.text = DetailString.Title.author
        $0.font = .systemFont(ofSize: fontSize, weight: .medium)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        return $0
    }(UILabel())
    
    private lazy var authorValueLabel: UILabel = {
        $0.numberOfLines = .zero
        $0.font = .systemFont(ofSize: fontSize, weight: .regular)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var dateLabel: UILabel = {
        $0.text = DetailString.Title.date
        $0.font = .systemFont(ofSize: fontSize, weight: .medium)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var dateValueLabel: UILabel = {
        $0.font = .systemFont(ofSize: fontSize, weight: .regular)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var titleStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = spacing
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var valueStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = spacing
        $0.alignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var infoStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = spacing
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        addConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        titleStackView.addArrangedSubview(nameLabel)
        titleStackView.addArrangedSubview(authorLabel)
        titleStackView.addArrangedSubview(dateLabel)
        
        valueStackView.addArrangedSubview(nameValueLabel)
        valueStackView.addArrangedSubview(authorValueLabel)
        valueStackView.addArrangedSubview(dateValueLabel)
        
        infoStackView.addArrangedSubview(titleStackView)
        infoStackView.addArrangedSubview(valueStackView)
        
        self.addSubview(imageView)
        self.addSubview(infoStackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: spacing),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            imageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -spacing),
            
            infoStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: spacing),
            infoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            infoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing)
        ])
    }
    
    func configureWith(model: DetailViewModel) {
        imageView.image = model.image
        nameValueLabel.text = model.name
        authorValueLabel.text = model.author
        dateValueLabel.text = model.date
    }
}

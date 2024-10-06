//
//  SearchViewCellController.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 29.09.24.
//

import Foundation
import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchCollectionViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: label.font.fontName, size: 14)
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var movieStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posterImageView,titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: MovieModel) {
        
        titleLabel.text = movie.title
        
        if let url = URL(string: movie.poster) {
            posterImageView.sd_setImage(with: url, completed: nil)
        }
    }

    private func setupView() {
        contentView.addSubview(movieStackView)
        
        NSLayoutConstraint.activate([
            movieStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieStackView.heightAnchor.constraint(equalToConstant: 283),
            movieStackView.widthAnchor.constraint(equalToConstant: 143)
        ])
    }
}


//
//  FavoriteMovieTableViewCell.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 06.10.24.
//

import UIKit
import SDWebImage

class FavoriteMovieTableViewCell: UITableViewCell {
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moviePlotLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewCell() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(moviePlotLabel)

        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 60),
            movieImageView.heightAnchor.constraint(equalToConstant: 90),
            
            movieTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieTitleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            moviePlotLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 5),
            moviePlotLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            moviePlotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            moviePlotLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with movie: MovieDetails) {
        movieTitleLabel.text = movie.title
        moviePlotLabel.text = movie.plot
        
        if let posterURL = movie.poster, let url = URL(string: posterURL ), posterURL != "" {
            movieImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            movieImageView.image = UIImage(systemName: "photo")
        }
    }
}


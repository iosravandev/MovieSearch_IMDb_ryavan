//
//  SearchDetailsViewController.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 03.10.24.
//

import UIKit
import SDWebImage
import CoreData

class SearchDetailsViewController: UIViewController {
    
    var movie: MovieModel?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let coreDataService = CoreDataService()
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let movieTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let movieStarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let movieRating: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moviePlot: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saveToFavorites: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        saveToFavorites.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(movieImageView)
        view.addSubview(movieTitle)
        view.addSubview(movieStarIcon)
        view.addSubview(movieRating)
        view.addSubview(moviePlot)
        view.addSubview(saveToFavorites)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 300),
            
            movieTitle.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 16),
            movieTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            movieStarIcon.leadingAnchor.constraint(equalTo: movieTitle.trailingAnchor, constant: 8),
            movieStarIcon.centerYAnchor.constraint(equalTo: movieTitle.centerYAnchor),
            movieStarIcon.widthAnchor.constraint(equalToConstant: 24),
            movieStarIcon.heightAnchor.constraint(equalToConstant: 24),
            
            movieRating.leadingAnchor.constraint(equalTo: movieStarIcon.trailingAnchor, constant: 8),
            movieRating.centerYAnchor.constraint(equalTo: movieStarIcon.centerYAnchor),
            
            moviePlot.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 16),
            moviePlot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moviePlot.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveToFavorites.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveToFavorites.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveToFavorites.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveToFavorites.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureImage(with movie: MovieModel) {
        if let url = URL(string: movie.poster) {
            movieImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    func configureTitle(with movie: MovieModel) {
        movieTitle.text = movie.title
        movieRating.text = "8.5"
    }
    
    func configurePlot(with plot: MovieModel) {
        moviePlot.text = plot.title
    }
    
    @objc func toggleFavorite() {
        guard let movie = movie else { return }

        if coreDataService.isFavorite(movie: movie) {
            coreDataService.removeFromFavorites(movie: movie)
            saveToFavorites.setTitle("Add to Favorites", for: .normal)
        } else {
            coreDataService.saveToFavorites(movie: movie)
            saveToFavorites.setTitle("Remove from Favorites", for: .normal)
        }
    }
    
    func isFavorite() -> Bool {
        let fetchRequest: NSFetchRequest<MovieDetails> = MovieDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie?.imdbID ?? "")
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Ошибка при проверке избранного: \(error)")
            return false
        }
    }
}

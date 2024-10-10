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

// MARK: - View Items
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let coreDataService = CoreDataService.shared
    var viewModel = SearchDetailsViewModel()
    var movie: MovieDetailsModel?
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let movieGenreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let movieDirectorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        
        guard let movie = movie else { return }
        print("Movie details in SearchDetailsViewController: \(movie)")
        
        guard let imdbID = movie.imdbID, !imdbID.isEmpty else {
            print("imdbID is missing or empty")
            return
        }

        viewModel.fetchMovieDetails(imdbID: imdbID) { [weak self] (result: Result<MovieDetailsModel, Error>) in
            switch result {
            case .success(let details):
                DispatchQueue.main.async {
                    self?.configureImage(with: details)
                    self?.configureTitle(with: details)
                    self?.configurePlot(with: details)
                    self?.configureGenre(with: details)
                    self?.configureReleaseDate(with: details)
                    self?.configureDirector(with: details)
                    self?.configureRating(with: details)
                }
            case .failure(let error):
                print("Error fetching movie details: \(error)")
            }
        }
    }
   
    
// MARK: - FUNCTIONS
    
    func setupView() {
            view.backgroundColor = .white
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            contentView.addSubview(movieImageView)
            contentView.addSubview(movieTitle)
            contentView.addSubview(movieStarIcon)
            contentView.addSubview(movieRatingLabel)
            contentView.addSubview(moviePlot)
            contentView.addSubview(movieGenreLabel)
            contentView.addSubview(movieReleaseDateLabel)
            contentView.addSubview(movieDirectorLabel)
            contentView.addSubview(saveToFavorites)

            NSLayoutConstraint.activate([
                
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
                movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                movieImageView.heightAnchor.constraint(equalToConstant: 300),
                
                movieTitle.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 16),
                movieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                movieTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                movieStarIcon.leadingAnchor.constraint(equalTo: movieTitle.trailingAnchor, constant: 8),
                movieStarIcon.centerYAnchor.constraint(equalTo: movieTitle.centerYAnchor),
                movieStarIcon.widthAnchor.constraint(equalToConstant: 24),
                movieStarIcon.heightAnchor.constraint(equalToConstant: 24),
                
                movieRatingLabel.leadingAnchor.constraint(equalTo: movieStarIcon.trailingAnchor, constant: 8),
                movieRatingLabel.centerYAnchor.constraint(equalTo: movieStarIcon.centerYAnchor),
                
                moviePlot.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 16),
                moviePlot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                moviePlot.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                movieGenreLabel.topAnchor.constraint(equalTo: moviePlot.bottomAnchor, constant: 16),
                movieGenreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                movieGenreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                movieReleaseDateLabel.topAnchor.constraint(equalTo: movieGenreLabel.bottomAnchor, constant: 8),
                movieReleaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                movieReleaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                movieDirectorLabel.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: 8),
                movieDirectorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                movieDirectorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                saveToFavorites.topAnchor.constraint(equalTo: movieDirectorLabel.bottomAnchor, constant: 16),
                saveToFavorites.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
                saveToFavorites.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                saveToFavorites.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                saveToFavorites.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    
    func configureTitle(with movie: MovieDetailsModel) {
        movieTitle.text = movie.title
    }

    func configurePlot(with movie: MovieDetailsModel) {
        moviePlot.text = movie.plot
    }

    func configureGenre(with movie: MovieDetailsModel) {
        movieGenreLabel.text = "Genre: \(movie.genre ?? "N/A")"
    }

    func configureReleaseDate(with movie: MovieDetailsModel) {
        movieReleaseDateLabel.text = "Release Date: \(movie.releaseDate ?? "N/A")"
    }

    func configureDirector(with movie: MovieDetailsModel) {
        movieDirectorLabel.text = "Director: \(movie.director ?? "N/A")"
    }

    func configureRating(with movie: MovieDetailsModel) {
        movieRatingLabel.text = "Rating: \(movie.imdbRating ?? "N/A")"
    }
    
    func configureImage(with movie: MovieDetailsModel) {
        if let urlString = movie.poster, let url = URL(string: urlString) {
            movieImageView.sd_setImage(with: url, completed: nil)
        } else {
            movieImageView.image = UIImage(systemName: "photo")
        }
    }
    
    func configurePlot(with plot: MovieModel) {
        moviePlot.text = plot.title
    }
    
    @objc func toggleFavorite() {
           guard let details = movie else { return }
           
           let movieModel = MovieModel(
               title: details.title ?? "Unknown",
               year: details.releaseDate ?? "Unknown",
               imdbID: details.imdbID ?? "",
               type: "movie",
               poster: details.poster ?? ""
           )
           
           if let movieEntity = coreDataService.fetchMovieEntity(by: movieModel.imdbID) {
               if coreDataService.isFavoriteEntity(movieEntity: movieEntity) {
                   coreDataService.removeFromFavorites(movie: movieEntity)
                   saveToFavorites.setTitle("Add to Favorites", for: .normal)
               } else {
                   coreDataService.saveToFavorites(movie: movieModel)
                   saveToFavorites.setTitle("Remove from Favorites", for: .normal)
               }
           } else {
               coreDataService.saveToFavorites(movie: movieModel)
               saveToFavorites.setTitle("Remove from Favorites", for: .normal)
           }
       }
    
    func isFavorite() -> Bool {
        let fetchRequest: NSFetchRequest<MovieDetails> = NSFetchRequest<MovieDetails>(entityName: "MovieDetailEntity")
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

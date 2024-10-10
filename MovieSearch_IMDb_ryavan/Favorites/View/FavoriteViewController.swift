//
//  FavoriteViewController.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 29.09.24.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let viewModel = SearchViewModel()

    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    var favoriteMovies: [MovieDetailEntity] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoriteView()
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: NSNotification.Name("FavoritesUpdated"), object: nil)
        
        fetchFavoriteMovies()

    }
    
    func setupFavoriteView() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteMovieTableViewCell.self, forCellReuseIdentifier: "FavoriteMovieCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        fetchFavorites()
    }
    
    @objc func updateFavorites() {
        fetchFavoriteMovies()
        tableView.reloadData()
    }
    
    func fetchFavoriteMovies() {
        favoriteMovies = CoreDataService.shared.fetchFavorites()
    }
    
    func fetchFavorites() {
        favoriteMovies = CoreDataService.shared.fetchFavorites()
        tableView.reloadData()
    }
    
    func openDetails(with movie: MovieModel) {
        let detailVC = SearchDetailsViewController()
        let imdbID = movie.imdbID
        
        viewModel.fetchMovieDetails(imdbID: imdbID) { [weak self] result in
            switch result {
            case .success(let details):
                DispatchQueue.main.async {
                    detailVC.movie = details
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            case .failure(let error):
                print("Error fetching movie details: \(error)")
            }
        }
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell", for: indexPath) as? FavoriteMovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: 10))
        spaceView.backgroundColor = .clear
        cell.contentView.addSubview(spaceView)
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.clipsToBounds = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = favoriteMovies[indexPath.row]
        let movieModel = MovieModel(
            title: selectedMovie.title ?? "",
            year: selectedMovie.year ?? "",
            imdbID: selectedMovie.imdbID ?? "",
            type: selectedMovie.type ?? "",
            poster: selectedMovie.poster ?? ""
        )
        openDetails(with: movieModel)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row < favoriteMovies.count else {
                print("Ошибка: индекс выходит за пределы массива.")
                return
            }
            
            let movieToDelete = favoriteMovies[indexPath.row]
            CoreDataService.shared.removeFromFavorites(movie: movieToDelete)
            fetchFavoriteMovies()
        }
    }
}

//
//  FavoriteViewController.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 29.09.24.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    var favoriteMovies: [MovieDetails] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoriteView()
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
    
    func fetchFavorites() {
        let fetchRequest: NSFetchRequest<MovieDetails> = MovieDetails.fetchRequest()
        do {
            favoriteMovies = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Ошибка загрузки данных: \(error)")
        }
    }
    
    func openDetails(with movie: MovieDetails) {
        let detailsVC = SearchDetailsViewController()
        
        let movieModel = MovieModel(title: (movie.imdbID ?? "" as NSObject as NSObject as! String) as! String, year: (movie.title ?? "" as NSObject as! String) as! String, imdbID: (movie.poster ?? "" as NSObject as! String) as! String, type: "", poster: "")
        
        detailsVC.movie = movieModel
        detailsVC.configureTitle(with: movieModel)
        detailsVC.configurePlot(with: movieModel)
        detailsVC.configureImage(with: movieModel)
        navigationController?.pushViewController(detailsVC, animated: true)
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
        openDetails(with: selectedMovie)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movieToDelete = favoriteMovies[indexPath.row]
            context.delete(movieToDelete)
            do {
                try context.save()
                favoriteMovies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Ошибка при удалении: \(error)")
            }
        }
    }
}

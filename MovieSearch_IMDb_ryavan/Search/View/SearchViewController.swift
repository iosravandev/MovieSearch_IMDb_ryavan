//
//  SearchViewController.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 29.09.24.
//

import Foundation
import UIKit


// MARK: - TabBarController

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    
    func setupTabBar() {
        
        let searchViewController = SearchViewController()
        let favoriteViewController = FavoriteViewController()
        
        searchViewController.title = "Find Movie"
        searchViewController.tabBarItem.image = UIImage(named: "iconmovie")
        
        favoriteViewController.title = "Favorites Movies"
        favoriteViewController.tabBarItem.image = UIImage(named: "favoritesicon")
        
        self.viewControllers = [UINavigationController(rootViewController: searchViewController), UINavigationController(rootViewController: favoriteViewController)]
        
    }
}

// MARK: - SearchViewController

class SearchViewController: UIViewController, UICollectionViewDelegate, CustomSearchBarDelegate {
    
    private let customSearchBar = CustomSearchBar()
    
    let viewModel = SearchViewModel()
    
    let detailsViewModel = SearchDetailsViewModel()
    
    lazy var mainCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 30
        flowLayout.minimumInteritemSpacing = 30
        flowLayout.itemSize = CGSize(width: 143, height: 283)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(mainCollectionView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        setupCustomSearchBar()
    }
    
    private func setupCustomSearchBar() {
        view.addSubview(customSearchBar)
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        customSearchBar.delegate = self
        
        NSLayoutConstraint.activate([
            customSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            customSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            customSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            customSearchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func searchBarDidSubmit(_ searchText: String) {
        viewModel.fetchMovies(for: searchText) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    print("Movies: \(movies)")
                    self?.mainCollectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch movies: \(error)")
            }
        }
    }
    
    func openDetails(with movie: MovieModel) {
        let detailsVC = SearchDetailsViewController()
        detailsVC.movie = movie
        detailsVC.configureTitle(with: movie)
        detailsVC.configurePlot(with: movie)
        detailsVC.configureImage(with: movie)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row + 1) clicked")
        let selectedMovie = viewModel.movies[indexPath.item]
        openDetails(with: selectedMovie)
    }
}

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
    
    // MARK: - Screen Items
    
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
    
    private let loadMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load More", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        mainCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        
    }
    
    // MARK: - Functions
    
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
        setupLoadMoreButton()
    }
    
    private func setupLoadMoreButton() {
        view.addSubview(loadMoreButton)
        NSLayoutConstraint.activate([
            loadMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadMoreButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loadMoreButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        loadMoreButton.addTarget(self, action: #selector(loadMoreMovies), for: .touchUpInside)
    }
    
    @objc private func loadMoreMovies() {
        guard !viewModel.currentSearchText.isEmpty else {
            print("No search text available")
            return
        }
        
        viewModel.currentPage += 1
        viewModel.fetchMovies(for: viewModel.currentSearchText, page: viewModel.currentPage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.mainCollectionView.reloadData()
                case .failure(let error):
                    print("Error loading more movies: \(error)")
                }
            }
        }
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
        viewModel.currentPage = 1
        viewModel.fetchMovies(for: searchText, page: viewModel.currentPage) { [weak self] result in
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
        let movieModel = MovieModel(
            title: movie.title ?? "No Title",
            year: movie.year ?? "No Year",
            imdbID: movie.imdbID ?? "No ID",
            type: movie.type ?? "No Type",
            poster: movie.poster ?? "No Poster"
        )
        
        print("Created movieModel: \(movieModel)")
        
        let detailVC = SearchDetailsViewController()
        
        viewModel.fetchMovieDetails(imdbID: movie.imdbID) { [weak self] (result: Result<MovieDetailsModel, Error>) in
            switch result {
            case .success(let details):
                DispatchQueue.main.async {
                    detailVC.movie = details
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            case .failure(let error):
                print("Failed to fetch movie details: \(error)")
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(loadMoreButton)
            loadMoreButton.frame = footer.bounds
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
}

//
//  SearchController.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 29.09.24.
//

import Foundation
import Alamofire

class SearchViewModel {
    
// MARK: - Variables & Constants
    
    let apiKey = "ada0588d"
    lazy var baseUrl = "http://www.omdbapi.com/?apikey=\(apiKey)&"
    lazy var posterBaseUrl = "http://img.omdbapi.com/?apikey=\(apiKey)&"
    var movies: [MovieModel] = []
    var completionHandler: ((Result<[MovieModel], Error>) -> Void)?
    var currentPage = 1
    var currentSearchText: String = ""

// MARK: - Functions
    
    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
        
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)&plot=full&r=json"
        
        AF.request("\(urlString)")
        .validate()
        .responseDecodable(of: MovieDetailsModel.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
    func fetchMovies(for searchTerm: String, page: Int, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        currentSearchText = searchTerm
        let endpoint = "s=\(searchTerm)&page=\(page)"
            
    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)&plot=full&r=json"
        AF.request(urlString)
                .validate()
                .responseDecodable(of: MovieDetailsModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
    }
    
    func fetchMovies(for searchTerm: String, page: Int, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        currentSearchText = searchTerm
        let endpoint = "s=\(searchTerm)&page=\(page)"
        NetworkManager.shared.fetchData(endpoint: endpoint) { (result: Result<MovieSearchResponse, Error>) in
            switch result {
            case .success(let response):
                if response.response == "True" {
                    self.movies.append(contentsOf: response.search)
                    completion(.success(response.search))
                } else {
                    completion(.success([]))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

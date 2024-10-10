//
//  SearchController.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 29.09.24.
//

import Foundation

class SearchViewModel {
    
    let apiKey = "ada0588d"
    lazy var baseUrl = "http://www.omdbapi.com/?apikey=\(apiKey)&"
    lazy var posterBaseUrl = "http://img.omdbapi.com/?apikey=\(apiKey)&"
    var movies: [MovieModel] = []
    var completionHandler: ((Result<[MovieModel], Error>) -> Void)?
    var currentPage = 1
    var currentSearchText: String = ""
    
    
    func searchMovies(tittle: String) {
        let urlString = baseUrl + "s=\(tittle)"
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Bearer ada0588d", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let movieResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                    self.movies = movieResponse.search
                    
                    DispatchQueue.main.async {
                        self.completionHandler?(.success(movieResponse.search))
                    }
                } catch {
                    print("JSON decoding error: \(error)")
                }
            }.resume()
            
            
        }
    }
    
    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)&plot=full&r=json"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "error"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "empty data"])))
                return
            }
            
            do {
                let details = try JSONDecoder().decode(MovieDetailsModel.self, from: data)
                completion(.success(details))
            } catch {
                completion(.failure(error))
            }
        }.resume()
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

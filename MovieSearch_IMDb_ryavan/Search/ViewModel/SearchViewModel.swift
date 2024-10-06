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
    
    func fetchMovies(for searchTerm: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let urlString = "http://www.omdbapi.com/?apikey=ada0588d&s=\(searchTerm)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Raw JSON Response: \(json)")
            }

            do {
                let movieResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)

                if movieResponse.response == "True" {
                    self.movies = movieResponse.search ?? []
                    completion(.success(movieResponse.search ?? []))
                } else {
                    print("API Error: No movies found or incorrect search query.")
                    completion(.success([]))
                }
            } catch let jsonError {
                print("Decoding error: \(jsonError)")
                completion(.failure(jsonError))
            }
        }.resume()
    }
}


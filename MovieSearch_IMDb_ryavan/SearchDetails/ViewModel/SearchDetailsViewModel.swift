//
//  SearchDetailsViewModel.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 03.10.24.
//

import Foundation

class SearchDetailsViewModel {
    
    private let apiKey = "ada0588d"
    private lazy var baseUrl = "http://www.omdbapi.com/?apikey=\(apiKey)&"
    private lazy var posterBaseUrl = "http://img.omdbapi.com/?apikey=\(apiKey)&"
    
    var movies: [MovieDetailsModel] = []
    var completionHandler: ((Result<[MovieDetailsModel], Error>) -> Void)?
    
    func searchMovies(title: String) {
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error encoding title")
            return
        }
        
        let urlString = "\(baseUrl)s=\(encodedTitle)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                self.completionHandler?(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error: \(response?.description ?? "No response")")
                self.completionHandler?(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
                return
            }
            
            guard let data = data else {
                print("No data received")
                self.completionHandler?(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let movieDetailsResponse = try JSONDecoder().decode(MovieDetailsSearchResponse.self, from: data)
                self.movies = movieDetailsResponse.search 
                
                DispatchQueue.main.async {
                    self.completionHandler?(.success(movieDetailsResponse.search ))
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                self.completionHandler?(.failure(error))
            }
        }.resume()
    }
}

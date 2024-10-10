//
//  SearchDetailsViewModel.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 03.10.24.
//

import Foundation

class SearchDetailsViewModel {
    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
        let endpoint = "i=\(imdbID)&plot=full"
        NetworkManager.shared.fetchData(endpoint: endpoint, completion: completion)
    }
}

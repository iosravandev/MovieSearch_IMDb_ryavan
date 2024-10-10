//
//  MovieModel.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 30.09.24.
//

import Foundation

struct MovieModel: Decodable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}

struct MovieSearchResponse: Decodable {
    let search: [MovieModel]
    let totalResults: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

//
//  MovieDetailsModel.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 06.10.24.
//

import Foundation

struct MovieDetailsModel: Decodable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    let plot: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
        case plot = "Plot"
    }
}

struct MovieDetailsSearchResponse: Decodable {
    
    let search: [MovieDetailsModel]
    let totalResults: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}


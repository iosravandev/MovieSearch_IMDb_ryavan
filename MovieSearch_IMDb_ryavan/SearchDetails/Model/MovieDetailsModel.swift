//
//  MovieDetailsModel.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 06.10.24.
//

import Foundation

struct MovieDetailsModel: Decodable {
    let title: String?
    let genre: String?
    let releaseDate: String?
    let director: String?
    let plot: String?
    let imdbRating: String?
    let poster: String?
    let imdbID: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case genre = "Genre"
        case releaseDate = "Released"
        case director = "Director"
        case plot = "Plot"
        case imdbRating = "imdbRating"
        case poster = "Poster"
        case imdbID = "imdbID"
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


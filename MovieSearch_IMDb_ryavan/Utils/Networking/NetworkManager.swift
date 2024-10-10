//
//  NetworkManager.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 10.10.24.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        let apiKey = "ada0588d"
        let baseUrl = "https://www.omdbapi.com/?apikey=\(apiKey)&"
        let urlString = "\(baseUrl)\(endpoint)"
        
        AF.request("\(urlString)")
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

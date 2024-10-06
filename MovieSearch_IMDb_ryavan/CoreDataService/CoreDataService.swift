//
//  CoreDataService.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 06.10.24.
//

import CoreData
import UIKit

class CoreDataService {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let container = NSPersistentContainer(name: "CoreData")

    func saveToFavorites(movie: MovieModel) {
        let fetchRequest: NSFetchRequest<MovieDetails> = MovieDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)

        do {
            let fetchedMovies = try context.fetch(fetchRequest)
            if fetchedMovies.isEmpty {
                let favoriteMovie = MovieDetails(context: context)
                favoriteMovie.imdbID = movie.imdbID
                favoriteMovie.title = movie.title
                favoriteMovie.poster = movie.poster
                //favoriteMovie.plot = movie.plot
                favoriteMovie.year = movie.year
                favoriteMovie.type = movie.type
                try context.save()
                print("Фильм сохранил")
            } else {
                print("Фильм добавил")
            }
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
    
    func removeFromFavorites(movie: MovieModel) {
        let fetchRequest: NSFetchRequest<MovieDetails> = MovieDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)

        do {
            let fetchedMovies = try context.fetch(fetchRequest)
            if let movieToDelete = fetchedMovies.first {
                context.delete(movieToDelete)
                try context.save()
                print("Фильм удален")
            }
        } catch {
            print("Ошибка удалении: \(error)")
        }
    }

    func isFavorite(movie: MovieModel) -> Bool {
        let fetchRequest: NSFetchRequest<MovieDetails> = MovieDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Ошибка: \(error)")
            return false
        }
    }
    
    func fetchFavorites() -> [MovieDetails] {
        let fetchRequest: NSFetchRequest<MovieDetails> = MovieDetails.fetchRequest()
        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            return favoriteMovies
        } catch {
            print("Ошибка: \(error)")
            return []
        }
    }
}


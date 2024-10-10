//
//  CoreDataService.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 06.10.24.
//

import UIKit
import Foundation
import CoreData

class CoreDataService {
    
    public static let shared = CoreDataService()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieSearch_IMDb_ryavan")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchEntity<T: NSManagedObject>(entityName: String, predicate: NSPredicate? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Ошибка - загрузка данных: \(error)")
            return []
        }
    }
    
    func saveToFavorites(movie: MovieModel) {
        let fetchRequest: NSFetchRequest<MovieDetailEntity> = NSFetchRequest<MovieDetailEntity>(entityName: "MovieDetailEntity")
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)
        do {
            let fetchedMovies = try viewContext.fetch(fetchRequest)
            if fetchedMovies.isEmpty {
                let favoriteMovie = MovieDetailEntity(context: viewContext)
                favoriteMovie.imdbID = movie.imdbID
                favoriteMovie.title = movie.title
                favoriteMovie.poster = movie.poster
                favoriteMovie.year = movie.year
                favoriteMovie.type = movie.type
                
                try viewContext.save()
                print("фильм сохранен")
                NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
            } else {
                print("фильм уже добавлен")
            }
        } catch {
            print("ошибка сохранения: \(error.localizedDescription)")
        }
    }
    
    func removeFromFavorites(movie: MovieDetailEntity) {
        let context = viewContext
        context.delete(movie)
        do {
            try context.save()
            print("фильм удален")
            NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
        } catch {
            print("ошибка удаления: \(error.localizedDescription)")
        }
    }
    
    func fetchMovieEntity(by imdbID: String) -> MovieDetailEntity? {
        let fetchRequest: NSFetchRequest<MovieDetailEntity> = MovieDetailEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", imdbID)
        
        do {
            let fetchedMovies = try viewContext.fetch(fetchRequest)
            return fetchedMovies.first
        } catch {
            print("ошибка загрузки : \(error.localizedDescription)")
            return nil
        }
    }
    
    func isFavorite(movie: MovieDetailEntity) -> Bool {
        let fetchRequest: NSFetchRequest<MovieDetailEntity> = NSFetchRequest<MovieDetailEntity>(entityName: "MovieDetailEntity")
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID ?? "")
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Ошибка при проверке избранного: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchFavorites() -> [MovieDetailEntity] {
        let fetchRequest: NSFetchRequest<MovieDetailEntity> = NSFetchRequest<MovieDetailEntity>(entityName: "MovieDetailEntity")
        do {
            let favoriteMovies = try viewContext.fetch(fetchRequest)
            return favoriteMovies
        } catch {
            print("Ошибка загрузки избранного: \(error.localizedDescription)")
            return []
        }
    }
    
    func isFavoriteEntity(movieEntity: MovieDetailEntity) -> Bool {
        let fetchRequest: NSFetchRequest<MovieDetailEntity> = NSFetchRequest<MovieDetailEntity>(entityName: "MovieDetailEntity")
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movieEntity.imdbID ?? "")
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Ошибка при проверке избранного: \(error.localizedDescription)")
            return false
        }
    }
    
    class func fetchRequest() -> NSFetchRequest<MovieDetailEntity> {
        return NSFetchRequest<MovieDetailEntity>(entityName: "MovieDetailEntity")
    }
    
}

//
//  MovieDetailEntity.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 06.10.24.
//

import Foundation
import CoreData

class MovieDetails: NSManagedObject {
    
    @NSManaged public var attribute: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var plot: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var year: String?
    
}

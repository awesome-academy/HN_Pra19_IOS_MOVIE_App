//
//  CoreDataStatistics.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 5/8/24.
//

import Foundation
import UIKit
import CoreData

final class CoreDataStatistics {
    static let shared = CoreDataStatistics()
    
    func save(item: SearchModel, isWatched: Bool) {
        guard let model = NSEntityDescription.insertNewObject(forEntityName: "MovieLocalModel",
                                                              into: CoreDataUtils.shared.privateManagedObjectContext) as? MovieLocalModel else {
            return
        }
        model.id = Int32(item.id)
        model.title = item.getName()
        model.mediaType = item.mediaType?.rawValue
        model.releaseDate = item.getReleaseDate()
        model.isWatched = isWatched
        model.posterPath = item.posterPath
        model.overview = item.overview
        CoreDataUtils.shared.saveData(objects: [model])
    }
    
    func fetch(isWatched: Bool) -> [MovieLocalModel] {
       
        let fetchRequest: NSFetchRequest<MovieLocalModel> = MovieLocalModel.fetchRequest()
        let queryWatched = NSPredicate(format: "isWatched == %@", NSNumber(value: isWatched))

        fetchRequest.predicate = NSCompoundPredicate.init(type: .and, subpredicates: [
            queryWatched
        ])

        var model = [MovieLocalModel]()
        CoreDataUtils.shared.mainManagedObjectContext.performAndWait {
            do {
                model = try CoreDataUtils.shared.mainManagedObjectContext.fetch(fetchRequest)
            } catch {
                print("Error fetching specific person data: \(error)")
            }
        }
        return model
    }
    
    func delete(item: SearchModel, isWatched: Bool) {
        let fetchRequest: NSFetchRequest<MovieLocalModel> = MovieLocalModel.fetchRequest()
        let queryWatched = NSPredicate(format: "isWatched == %@", NSNumber(value: isWatched))
        let queryID = NSPredicate(format: "id == %@ ", NSNumber(value: item.id))
        
        fetchRequest.predicate = NSCompoundPredicate.init(type: .and, subpredicates: [
            queryID,
            queryWatched,
        ])
        
        var model = [MovieLocalModel]()
        
        CoreDataUtils.shared.mainManagedObjectContext.performAndWait {
            do {
                model = try CoreDataUtils.shared.mainManagedObjectContext.fetch(fetchRequest)
            } catch {
                print("Error fetching specific person data: \(error)")
            }
        }
        
        CoreDataUtils.shared.deleteData(objects: model)
    }
}

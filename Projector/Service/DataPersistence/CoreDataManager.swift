//
//  CoreDataService.swift
//  Projector
//
//  Created by Fatih Gursoy on 15.02.2022.
//

import Foundation
import CoreData

class CoreDataManager {

    init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Projector")
        
        container.loadPersistentStores(completionHandler: { _, error in
                    _ = error.map { fatalError("Unresolved error \($0)") }
        })
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var fetchRequest: NSFetchRequest<WatchList> = WatchList.fetchRequest()
    
// -MARK: Functions
    
    func fetchData() -> [WatchList] {

        guard let requests = try? mainContext.fetch(fetchRequest) else { return [] }
        return requests
    }
    
    var watchList: [WatchList] {
        let items = fetchData()
        return items
    }
    
    func fetchMovie(_ movieId: String) -> WatchList? {
                
        guard let request = try? mainContext.fetch(fetchRequest) else { return WatchList() }
        
        let movie = request.filter { $0.movieId == movieId }
        return movie.first
    }
    
    func addNewMovie(_ movieId: String?) {
        
        guard let movieId = movieId else { return }
        
        if watchList.filter({ $0.movieId == movieId }).count < 1 {
            
            let newMovie = WatchList(context: mainContext)
            newMovie.movieId = movieId
            newMovie.isWatched = false
                
            do {
                try self.mainContext.save()
            } catch {
                let error = error as NSError
                print("Unable to Save: \(error)")
            }
        } 
    }
    
    func updateMovie(_ movieId: String) -> Bool {
    
        let movies = watchList.filter { $0.movieId == movieId }
        guard let movie = movies.first else { return false }
        movie.isWatched = !(movie.isWatched)
        
        do {
            try self.mainContext.save()
        } catch {
            let error = error as NSError
            print("Unable to Save: \(error)")
        }
        
        return movie.isWatched
    }
    
    func deleteMovie(with item: NSManagedObject) {
        
        mainContext.delete(item)
        
        do {
            try self.mainContext.save()
        } catch {
            let error = error as NSError
            print("Unable to Delete: \(error)")
        }
        
    }

}

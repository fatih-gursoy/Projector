//
//  CoreDataService.swift
//  Projector
//
//  Created by Fatih Gursoy on 15.02.2022.
//

import Foundation
import CoreData

class CoreService {
    
    private let context = CoreDataModel.context
    private let fetchRequest = NSFetchRequest<WatchList>(entityName: CoreDataModel.entitiyName)
 
    func fetchData() -> [WatchList] {

        guard let requests = try? context.fetch(fetchRequest) else { return [] }
        
        return requests
    }
    
    var watchList: [WatchList] {
        
        let items = fetchData()
        return items
        
    }
    
    func fetchMovie(_ movieId: String) -> WatchList? {
                
        guard let request = try? context.fetch(fetchRequest) else { return WatchList() }
        
        let movie = request.filter { $0.movieId == movieId }
        return movie.first

    }
    
    func saveToCoreData() {
        
        do {
           try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(with item: NSManagedObject) {
        
        context.delete(item)
        saveToCoreData()
    }

}

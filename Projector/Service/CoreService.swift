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

        var requests = [WatchList]()
        
        do {
            requests = try context.fetch(fetchRequest)
            return requests
        } catch {
            print(error.localizedDescription)
        }
        return requests
    }
    
    var watchList: [WatchList] {
        
        let items = fetchData()
        return items
        
    }
    
    func fetchMovie(_ movieId: String) -> WatchList? {
        
        var requests = [WatchList]()
        
        do {
            requests = try context.fetch(fetchRequest)
            let movie = requests.filter { $0.movieId == movieId }
            return movie.first
            
        } catch {
            print(error.localizedDescription)
        }

        return WatchList()
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

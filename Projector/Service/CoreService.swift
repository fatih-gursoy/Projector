//
//  CoreDataService.swift
//  Projector
//
//  Created by Fatih Gursoy on 15.02.2022.
//

import Foundation
import CoreData

class CoreService {
    
    let context = CoreDataModel.context
    let fetchRequest = NSFetchRequest<WatchList>(entityName: CoreDataModel.entitiyName)
 
    func fetchWatchList() -> [WatchList] {

        var requests = [WatchList]()

        do {
            requests = try context.fetch(fetchRequest)
            return requests
        } catch {
            print(error.localizedDescription)
        }
        return requests
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
    }

}

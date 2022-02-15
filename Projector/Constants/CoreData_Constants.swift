//
//  CoreDataModel.swift
//  Projector
//
//  Created by Fatih Gursoy on 15.02.2022.
//

import Foundation
import UIKit

struct CoreDataModel {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    static let entitiyName = "WatchList"
}

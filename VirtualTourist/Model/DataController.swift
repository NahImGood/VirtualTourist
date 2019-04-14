//
//  DataController.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/11/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    var persistantController: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistantController.viewContext
    }
    
    init(modelName: String){
         persistantController = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (()-> Void)? = nil){
        persistantController.loadPersistentStores { (data, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.saveInInterval(interval: 3)
            completion?()
        }
    }
}

extension DataController {
    func saveInInterval(interval: TimeInterval = 3){
        guard interval > 0 else {
            print("Interval cant be less than 0")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval){
            self.saveInInterval(interval: interval)
        }
    }
}

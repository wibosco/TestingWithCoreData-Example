//
//  CoreDataManager+Store.swift
//  TestingWithCoreData-ExampleTests
//
//  Created by William Boles on 25/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import Foundation
import CoreData
@testable import TestingWithCoreData_Example

extension CoreDataManager {
    
    func destroySQLitePersistentStore() {
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
            return
        }
        
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
            try persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
        } catch let error {
            print("failed to destroy persistent store at \(storeURL), error: \(error)")
        }
    }
}

//
//  CoreDataManager.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 11/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    // MARK: - Init
    
    private init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.backgroundContext = backgroundContext
        
        let mainContext = persistentContainer.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
        self.mainContext = mainContext
    }
    
    // MARK: - SetUp
    
    static func setUp(storeType: String = NSSQLiteStoreType,
                      completion: @escaping (Result<CoreDataManager, Error>) -> Void) {
        let container = NSPersistentContainer(name: "TestingWithCoreData_Example")
        let description = container.persistentStoreDescriptions.first
        description?.type = storeType
        
        container.loadPersistentStores { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(CoreDataManager(persistentContainer: container)))
        }
    }
}

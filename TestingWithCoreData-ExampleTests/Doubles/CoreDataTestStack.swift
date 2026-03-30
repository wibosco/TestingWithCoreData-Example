//
//  CoreDataHelpers.swift
//  TestingWithCoreData-ExampleTests
//
//  Created by William Boles on 10/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import XCTest
import CoreData

@testable import TestingWithCoreData_Example

class CoreDataTestStack {
    
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContextSpy
    let mainContext: NSManagedObjectContextSpy
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TestingWithCoreData_Example")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContextSpy(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        backgroundContext = NSManagedObjectContextSpy(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}

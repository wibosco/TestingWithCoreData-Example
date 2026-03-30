//
//  NSPersistentContainer+Store.swift
//  TestingWithCoreData-ExampleTests
//
//  Created by William Boles on 25/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import Foundation
import CoreData

@testable import TestingWithCoreData_Example

extension NSPersistentContainer {
    func destroyPersistentStore() throws {
        guard let storeURL = persistentStoreDescriptions.first?.url,
              let storeType = persistentStoreDescriptions.first?.type else {
            return
        }
        
        try persistentStoreCoordinator.destroyPersistentStore(at: storeURL,
                                                              ofType: storeType,
                                                              options: nil)
    }
}

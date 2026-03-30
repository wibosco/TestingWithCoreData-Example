//
//  CoreDataManager+Testing.swift
//  TestingWithCoreData-ExampleTests
//
//  Created by William Boles on 30/03/2026.
//  Copyright © 2026 William Boles. All rights reserved.
//

import Foundation
import CoreData

@testable import TestingWithCoreData_Example

extension CoreDataManager {
    static func setUpForTesting() -> CoreDataManager {
        var manager: CoreDataManager!
        
        let semaphore = DispatchSemaphore(value: 0)
        
        setUp(storeType: NSInMemoryStoreType) { result in
            manager = try? result.get()
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return manager
    }
}

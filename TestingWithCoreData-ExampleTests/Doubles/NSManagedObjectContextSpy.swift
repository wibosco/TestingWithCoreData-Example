//
//  NSManagedObjectContextSpy.swift
//  TestingWithCoreData-ExampleTests
//
//  Created by William Boles on 30/03/2026.
//  Copyright © 2026 William Boles. All rights reserved.
//

import Foundation
import CoreData
import XCTest

@testable import TestingWithCoreData_Example

class NSManagedObjectContextSpy: NSManagedObjectContext {
    var expectation: XCTestExpectation?
    
    var saveWasCalled = false
    
    // MARK: - Perform
    
    override func performAndWait(_ block: () -> Void) {
        super.performAndWait(block)
        
        expectation?.fulfill()
    }
    
    // MARK: - Save
    
    override func save() throws {
        try super.save()
        
        saveWasCalled = true
    }
}

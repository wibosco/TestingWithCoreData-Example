//
//  CoreDataManagerTests.swift
//  TestingWithCoreData-ExampleTests
//
//  Created by William Boles on 12/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import XCTest
import CoreData
@testable import TestingWithCoreData_Example

class CoreDataManagerTests: XCTestCase {
    
    // MARK: Properties
    
    var sut: CoreDataManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        sut = CoreDataManager()
    }
    
    // MARK: - Tests
    
    // MARK: Setup

    func test_setup_completionCalled() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup {
            setupExpectation.fulfill()
        }
        
        wait(for: [setupExpectation], timeout: 1.0)
    }
    
    func test_setup_persistentContainerLoadedOnDisk() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup {
            XCTAssertEqual(self.sut.persistentContainer.persistentStoreDescriptions.first?.type, NSSQLiteStoreType)
            setupExpectation.fulfill()
        }
        
        wait(for: [setupExpectation], timeout: 1.0)
    }
    
    func test_setup_persistentContainerLoadedInMemory() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.sut.persistentContainer.persistentStoreDescriptions.first?.type, NSInMemoryStoreType)
            setupExpectation.fulfill()
        }
        
        wait(for: [setupExpectation], timeout: 1.0)
    }
    
    // MARK: Contexts
    
    func test_backgroundContext_concurrencyType() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.sut.backgroundContext.concurrencyType, .privateQueueConcurrencyType)
            setupExpectation.fulfill()
        }
        
        wait(for: [setupExpectation], timeout: 1.0)
    }
    
    func test_mainContext_concurrencyType() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.sut.mainContext.concurrencyType, .mainQueueConcurrencyType)
            setupExpectation.fulfill()
        }
        
        wait(for: [setupExpectation], timeout: 1.0)
    }
}

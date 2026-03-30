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
    var sut: CoreDataManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        sut = CoreDataManager()
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut.persistentContainer.destroyPersistentStore()
    }
    
    // MARK: - Tests
    
    // MARK: Setup

    func test_givenAFreshStack_whenSetupFinishes_thenCompletionIsCalled() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup(storeType: NSInMemoryStoreType) {
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_givenNoSetup_whenSetupFinishes_thenPersistentStoreIsCreated() {
       let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup(storeType: NSInMemoryStoreType) {
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertTrue(self.sut.persistentContainer.persistentStoreCoordinator.persistentStores.count > 0)
        }
    }
    
    func test_givenNoSetup_whenSetupFinishes_thenPersistentContainerLoadedOnDisk() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup {
            XCTAssertEqual(self.sut.persistentContainer.persistentStoreDescriptions.first?.type, NSSQLiteStoreType)
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_givenNoSetup_whenSetupFinishes_thenPersistentContainerLoadedInMemory() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.sut.persistentContainer.persistentStoreDescriptions.first?.type, NSInMemoryStoreType)
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: Contexts
    
    func test_givenASetUpStack_thenBackgroundContextIsAPrivateQueue() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.sut.backgroundContext.concurrencyType, .privateQueueConcurrencyType)
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_givenASetUpStack_thenMainContextIsTheMainQueue() {
        let setupExpectation = expectation(description: "set up completion called")
        
        sut.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.sut.mainContext.concurrencyType, .mainQueueConcurrencyType)
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

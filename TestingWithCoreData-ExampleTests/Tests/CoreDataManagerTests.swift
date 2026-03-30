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
    
    // MARK: - Tests
    
    // MARK: Setup
    
    func test_givenNoSetup_whenSetUpFinishes_thenCoreDataManagerIsCreated() {
        let setUpExpectation = expectation(description: "SetUp completion called")
        
        CoreDataManager.setUp(storeType: NSInMemoryStoreType) { result in
            defer { setUpExpectation.fulfill() }
            
            guard let _ = try? result.get() else {
                XCTFail("Failed to set up Core Data stack")
                return
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_givenNoSetup_whenSetUpFinishes_thenPersistentContainerLoadedOnDisk() {
        let setUpExpectation = expectation(description: "SetUp completion called")
        
        CoreDataManager.setUp { result in
            defer { setUpExpectation.fulfill() }
            
            guard let sut = try? result.get() else {
                XCTFail("Failed to set up Core Data stack")
                return
            }
            
            XCTAssertEqual(sut.persistentContainer.persistentStoreDescriptions.first?.type, NSSQLiteStoreType)
            
            try? sut.persistentContainer.destroyPersistentStore()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_givenNoSetup_whenSetUpFinishes_thenPersistentContainerLoadedInMemory() {
        let setUpExpectation = expectation(description: "SetUp completion called")
        
        CoreDataManager.setUp(storeType: NSInMemoryStoreType) { result in
            defer { setUpExpectation.fulfill() }
            
            guard let sut = try? result.get() else {
                XCTFail("Failed to set up Core Data stack")
                return
            }
            
            XCTAssertEqual(sut.persistentContainer.persistentStoreDescriptions.first?.type, NSInMemoryStoreType)
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: Contexts
    
    func test_givenASetUpStack_thenBackgroundContextIsAPrivateQueue() {
        let setUpExpectation = expectation(description: "SetUp completion called")
        
        CoreDataManager.setUp(storeType: NSInMemoryStoreType) { result in
            defer { setUpExpectation.fulfill() }
            
            guard let sut = try? result.get() else {
                XCTFail("Failed to set up Core Data stack")
                return
            }
            
            XCTAssertEqual(sut.backgroundContext.concurrencyType, .privateQueueConcurrencyType)
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_givenASetUpStack_thenMainContextIsTheMainQueue() {
        let setUpExpectation = expectation(description: "SetUp completion called")
        
        CoreDataManager.setUp(storeType: NSInMemoryStoreType) { result in
            defer { setUpExpectation.fulfill() }
            
            guard let sut = try? result.get() else {
                XCTFail("Failed to set up Core Data stack")
                return
            }
            
            XCTAssertEqual(sut.mainContext.concurrencyType, .mainQueueConcurrencyType)
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_givenASetUpStack_thenBackgroundContextMergePolicyIsPropertyObjectTrump() {
        let setUpExpectation = expectation(description: "SetUp completion called")
        
        CoreDataManager.setUp(storeType: NSInMemoryStoreType) { result in
            defer { setUpExpectation.fulfill() }
            
            guard let sut = try? result.get() else {
                XCTFail("Failed to set up Core Data stack")
                return
            }
            
            XCTAssertTrue(sut.backgroundContext.mergePolicy is NSMergePolicy)
            XCTAssertEqual((sut.backgroundContext.mergePolicy as? NSMergePolicy)?.mergeType, .mergeByPropertyObjectTrumpMergePolicyType)
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_givenASetUpStack_thenMainContextAutomaticallyMergesChangesFromParent() {
        let setUpExpectation = expectation(description: "SetUp completion called")
        
        CoreDataManager.setUp(storeType: NSInMemoryStoreType) { result in
            defer { setUpExpectation.fulfill() }
            
            guard let sut = try? result.get() else {
                XCTFail("Failed to set up Core Data stack")
                return
            }
            
            XCTAssertTrue(sut.mainContext.automaticallyMergesChangesFromParent)
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

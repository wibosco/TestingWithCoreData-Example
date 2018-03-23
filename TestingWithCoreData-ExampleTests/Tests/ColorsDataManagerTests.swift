//
//  ColorsDataManagerTests.swift
//  TestingWithCoreData-ExampleTests
//
//  Created by William Boles on 08/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import XCTest
import CoreData
@testable import TestingWithCoreData_Example

class ColorsDataManagerTests: XCTestCase {
    
    // MARK: Properties
    
    var sut: ColorsDataManager!
    
    var coreDataStack: CoreDataTestStack!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataTestStack()
        
        sut = ColorsDataManager(backgroundContext: coreDataStack.backgroundContext)
    }
    
    // MARK: - Tests
    
    // MARK: Init
    
    func test_init_contexts() {
        XCTAssertEqual(sut.backgroundContext, coreDataStack.backgroundContext)
    }
    
    // MARK: Create
    
    func test_createColor_colorCreated() {
        let performAndWaitExpectation = expectation(description: "background perform and wait")
        coreDataStack.backgroundContext.expectation = performAndWaitExpectation
        
        sut.createColor()
        
        waitForExpectations(timeout: 1) { (_) in
            let request = NSFetchRequest<Color>.init(entityName: Color.className)
            let colors = try! self.coreDataStack.backgroundContext.fetch(request)
            
            guard let color = colors.first else {
                XCTFail("color missing")
                return
            }
            
            XCTAssertEqual(colors.count, 1)
            XCTAssertNotNil(color.hex)
            XCTAssertEqual(color.dateCreated?.timeIntervalSinceNow ?? 0, Date().timeIntervalSinceNow, accuracy: 0.1)
            XCTAssertTrue(self.coreDataStack.backgroundContext.saveWasCalled)
        }
    }
    
    // MARK: Deletion
    
    func test_deleteColor_colorDeleted() {
        let performAndWaitExpectation = expectation(description: "background perform and wait")
        coreDataStack.backgroundContext.expectation = performAndWaitExpectation
        
        let colorA = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: self.coreDataStack.backgroundContext) as! Color
        let colorB = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: self.coreDataStack.backgroundContext) as! Color
        let colorC = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: self.coreDataStack.backgroundContext) as! Color
        
        sut.deleteColor(color: colorB)
        
        waitForExpectations(timeout: 1) { (_) in
            let request = NSFetchRequest<Color>.init(entityName: Color.className)
            let backgroundContextColors = try! self.coreDataStack.backgroundContext.fetch(request)
            
            XCTAssertEqual(backgroundContextColors.count, 2)
            XCTAssertTrue(backgroundContextColors.contains(colorA))
            XCTAssertTrue(backgroundContextColors.contains(colorC))
            XCTAssertTrue(self.coreDataStack.backgroundContext.saveWasCalled)
        }
    }
}

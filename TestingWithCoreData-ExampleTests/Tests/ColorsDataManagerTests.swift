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
    
    var backgroundContext: NSManagedObjectContextSpy!
    var mainContext: NSManagedObjectContextSpy!

    var coreDataStack: CoreDataTestStack!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataTestStack()
        
        backgroundContext = coreDataStack.backgroundContext
        mainContext = coreDataStack.mainContext

        sut = ColorsDataManager(mainContext: mainContext, backgroundContext: backgroundContext)
    }
    
    // MARK: - Tests
    
    // MARK: Init
    
    func test_init_contexts() {
        XCTAssertEqual(sut.backgroundContext, backgroundContext)
        XCTAssertEqual(sut.mainContext, mainContext)
    }
    
    // MARK: Colors
    
    func test_colors_returnAll() {
        _ = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: self.mainContext)
        _ = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: self.mainContext)
        
        let colors = sut.colors()
        
        XCTAssertEqual(colors.count, 2)
    }
    
    func test_colors_orderedByDate() {
        let colorA = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: self.mainContext) as! Color
        colorA.dateCreated = Date.distantPast
        let colorB = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: self.mainContext) as! Color
        colorB.dateCreated = Date.distantFuture
        
        let colors = sut.colors()
        
        XCTAssertEqual(colors[0], colorB)
        XCTAssertEqual(colors[1], colorA)
    }
    
    func test_colors_returnEmpty() {
        let colors = sut.colors()
        
        XCTAssertEqual(colors.count, 0)
    }
    
    // MARK: Create
    
    func test_createColor_colorCreated() {
        let performAndWaitExpectation = expectation(description: "background perform and wait")
        backgroundContext.expectation = performAndWaitExpectation
        
        sut.createColor()
        
        waitForExpectations(timeout: 1) { (_) in
            let request = NSFetchRequest<Color>.init(entityName: Color.className)
            let colors = try! self.mainContext.fetch(request)
            
            guard let color = colors.first else {
                XCTFail("color missing")
                return
            }
            
            XCTAssertEqual(colors.count, 1)
            XCTAssertNotNil(color.hex)
            XCTAssertEqual(color.dateCreated?.timeIntervalSinceNow ?? 0, Date().timeIntervalSinceNow, accuracy: 0.1)
            XCTAssertTrue(self.backgroundContext.saveWasCalled)
        }
    }
    
    // MARK: Deletion
    
    func test_deleteColor_colorDeleted() {
        let performAndWaitExpectation = expectation(description: "background perform and wait")
        backgroundContext.expectation = performAndWaitExpectation
        
        let color = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: self.backgroundContext) as! Color
        
        sut.deleteColor(color: color)
        
        waitForExpectations(timeout: 1) { (_) in
            let request = NSFetchRequest<Color>.init(entityName: Color.className)
            let backgroundContextColors = try! self.mainContext.fetch(request)
            let mainContextColors = try! self.mainContext.fetch(request)
            
            XCTAssertEqual(backgroundContextColors.count, 0)
            XCTAssertEqual(mainContextColors.count, 0)
        }
    }
}

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

class ColorManagerTests: XCTestCase {
    var sut: ColorManager!
    
    var coreDataStack: TestCoreDataStack!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack()
        
        sut = ColorManager(backgroundContext: coreDataStack.backgroundContext)
    }
    
    // MARK: - Tests
    
    // MARK: Init
    
    func test_whenColorsDataManagerIsInitialised_thenContextIsSetUp() {
        XCTAssertEqual(sut.backgroundContext, coreDataStack.backgroundContext)
    }
    
    // MARK: Create
    
    func test_whenCreateColorIsCalled_thenAColorRecordIsCreated() {
        sut.createColor()
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let colors = try! coreDataStack.backgroundContext.fetch(request)
        
        guard let color = colors.first else {
            XCTFail("color missing")
            return
        }
        
        XCTAssertEqual(colors.count, 1)
        XCTAssertNotNil(color.hex)
        XCTAssertEqual(color.dateCreated?.timeIntervalSinceNow ?? 0, Date().timeIntervalSinceNow, accuracy: 0.1)
    }
    
    func test_whenCreateColorIsCalledMultipleTimes_thenMultipleColorRecordsAreCreated() {
        sut.createColor()
        sut.createColor()
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let colors = try! coreDataStack.backgroundContext.fetch(request)
        
        XCTAssertEqual(colors.count, 2)
        XCTAssertNotEqual(colors[0].hex, colors[1].hex)
    }
    
    // MARK: Deletion
    
    func test_whenDeleteColorIsCalled_thenColorRecordIsDeleted() {
        let colorA = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        let colorB = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        let colorC = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        
        sut.deleteColor(color: colorB)
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let backgroundContextColors = try! coreDataStack.backgroundContext.fetch(request)
        
        XCTAssertEqual(backgroundContextColors.count, 2)
        XCTAssertTrue(backgroundContextColors.contains(colorA))
        XCTAssertTrue(backgroundContextColors.contains(colorC))
    }
    
    func test_givenAColorInstanceFromTheMainContext_whenDeleteColorIsCalled_thenColorRecordIsDeleted() {
        let colorA = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        let colorB = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        let colorC = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        
        let mainContextColor = coreDataStack.mainContext.object(with: colorB.objectID) as! Color
        
        sut.deleteColor(color: mainContextColor)
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let backgroundContextColors = try! coreDataStack.backgroundContext.fetch(request)
        
        XCTAssertEqual(backgroundContextColors.count, 2)
        XCTAssertTrue(backgroundContextColors.contains(colorA))
        XCTAssertTrue(backgroundContextColors.contains(colorC))
    }
    
    func test_givenAnAlreadyDeletedColor_whenDeleteColorIsCalledAgain_thenNoAdditionalRecordsAreDeleted() {
        let colorA = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        let colorB = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        let colorC = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: coreDataStack.backgroundContext) as! Color
        
        sut.deleteColor(color: colorB)
        sut.deleteColor(color: colorB)
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let colors = try! coreDataStack.backgroundContext.fetch(request)
        
        XCTAssertEqual(colors.count, 2)
        XCTAssertTrue(colors.contains(colorA))
        XCTAssertTrue(colors.contains(colorC))
    }
}

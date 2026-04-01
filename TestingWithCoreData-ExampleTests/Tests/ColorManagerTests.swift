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
    var coreDataManager: CoreDataManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        coreDataManager = CoreDataManager.setUpForTesting()
        
        sut = ColorManager(backgroundContext: coreDataManager.backgroundContext)
    }
    
    // MARK: - Tests
    
    // MARK: Init
    
    func test_whenColorManagerIsInitialised_thenContextIsSetUp() {
        XCTAssertEqual(sut.backgroundContext, coreDataManager.backgroundContext)
    }
    
    // MARK: Create
    
    func test_whenCreateColorIsCalled_thenAColorRecordIsCreated() {
        let hex = UIColor.random.hexString
        let date = Date.distantPast
        
        sut.createColor(hex: hex,
                        date: date)
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let colors = try! coreDataManager.backgroundContext.fetch(request)
        
        guard let color = colors.first else {
            XCTFail("color missing")
            return
        }
        
        XCTAssertEqual(colors.count, 1)
        XCTAssertEqual(color.hex, hex)
        XCTAssertEqual(color.dateCreated, date)
    }
    
    func test_whenCreateColorIsCalledMultipleTimes_thenMultipleColorRecordsAreCreated() {
        sut.createColor()
        sut.createColor()
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let colors = try! coreDataManager.backgroundContext.fetch(request)
        
        XCTAssertEqual(colors.count, 2)
        XCTAssertNotEqual(colors[0].hex, colors[1].hex)
    }
    
    // MARK: Deletion
    
    func test_whenDeleteColorIsCalled_thenColorRecordIsDeleted() {
        let colorA = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        let colorB = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        let colorC = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        
        sut.deleteColor(colorB)
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let backgroundContextColors = try! coreDataManager.backgroundContext.fetch(request)
        
        XCTAssertEqual(backgroundContextColors.count, 2)
        XCTAssertTrue(backgroundContextColors.contains(colorA))
        XCTAssertTrue(backgroundContextColors.contains(colorC))
    }
    
    func test_givenAColorInstanceFromTheMainContext_whenDeleteColorIsCalled_thenColorRecordIsDeleted() {
        let colorA = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        let colorB = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        let colorC = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        
        let mainContextColor = coreDataManager.mainContext.object(with: colorB.objectID) as! Color
        
        sut.deleteColor(mainContextColor)
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let backgroundContextColors = try! coreDataManager.backgroundContext.fetch(request)
        
        XCTAssertEqual(backgroundContextColors.count, 2)
        XCTAssertTrue(backgroundContextColors.contains(colorA))
        XCTAssertTrue(backgroundContextColors.contains(colorC))
    }
    
    func test_givenAnAlreadyDeletedColor_whenDeleteColorIsCalledAgain_thenNoAdditionalRecordsAreDeleted() {
        let colorA = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        let colorB = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        let colorC = NSEntityDescription.insertNewObject(forEntityName: Color.className,
                                                         into: coreDataManager.backgroundContext) as! Color
        
        sut.deleteColor(colorB)
        sut.deleteColor(colorB)
        
        let request = NSFetchRequest<Color>(entityName: Color.className)
        let colors = try! coreDataManager.backgroundContext.fetch(request)
        
        XCTAssertEqual(colors.count, 2)
        XCTAssertTrue(colors.contains(colorA))
        XCTAssertTrue(colors.contains(colorC))
    }
}

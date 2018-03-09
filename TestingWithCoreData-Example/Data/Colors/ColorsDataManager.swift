//
//  ColorsDataManager.swift
//  TestingWithCoreData-Example
//
//  Created by William Boles on 09/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import UIKit
import CoreData

class ColorsDataManager {
 
    private let mainContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    
    // MARK: - Init
    
    init(mainContext: NSManagedObjectContext = CoreDataManager.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
    
    // MARK: - Colors
    
    func colors() -> [Color] {
        let request = NSFetchRequest<Color>.init(entityName: "Color")
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateSort]

        return try! mainContext.fetch(request)
    }
    
    // MARK: - Create
    
    func insertColor() {
        backgroundContext.performAndWait {
            let color = NSEntityDescription.insertNewObject(forEntityName: "Color", into: backgroundContext) as! Color
            color.hex = UIColor.random.hexString
            color.date = Date()
            
            try! backgroundContext.save()
        }
    }
    
    // MARK: - Deletion
    
    func deleteColor(color: Color) {
        backgroundContext.performAndWait {
            backgroundContext.delete(color)
            
            try! backgroundContext.save()
        }
    }
}

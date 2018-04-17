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
 
    let backgroundContext: NSManagedObjectContext
    
    // MARK: - Init
    
    init(backgroundContext: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.backgroundContext = backgroundContext
    }
    
    // MARK: - Create
    
    func createColor() {
        backgroundContext.performAndWait {
            let color = NSEntityDescription.insertNewObject(forEntityName: Color.className, into: backgroundContext) as! Color
            color.hex = UIColor.random.hexString
            color.dateCreated = Date()
            
            try! backgroundContext.save()
        }
    }
    
    // MARK: - Deletion
    
    func deleteColor(color: Color) {
        let objectID = color.objectID
        backgroundContext.performAndWait {
            if let colorInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(colorInContext)
                try? backgroundContext.save()
            }
        }
    }
}

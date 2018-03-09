//
//  CGFloat+Random.swift
//  TestingWithCoreData-Example
//
//  Created by William Boles on 08/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    
    // MARK: - Random
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

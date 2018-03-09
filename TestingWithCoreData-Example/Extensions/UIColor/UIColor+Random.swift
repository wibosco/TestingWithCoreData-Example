//
//  UIColor+Random.swift
//  TestingWithCoreData-Example
//
//  Created by William Boles on 08/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Random
    
    static var random: UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}

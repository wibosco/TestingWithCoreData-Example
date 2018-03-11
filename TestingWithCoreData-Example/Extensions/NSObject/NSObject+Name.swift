//
//  NSObject+Name.swift
//  TestingWithCoreData-Example
//
//  Created by William Boles on 08/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import Foundation

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

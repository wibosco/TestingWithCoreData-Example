//
//  AppDelegate.swift
//  TestingWithCoreData-Example
//
//  Created by William Boles on 08/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataManager.shared.setup {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // just for example purposes
                self.presentMainUI()
            }
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        try? CoreDataManager.shared.mainContext.save()
    }
    
    // MARK: - Main
    
    func presentMainUI() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = mainStoryboard.instantiateInitialViewController()
    }
}


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
    var coreDataManager: CoreDataManager?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataManager.setUp { result in
            switch result {
            case .success(let manager):
                self.coreDataManager = manager
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.presentMainUI()
                }
            case .failure(let error):
                fatalError("was unable to load store \(error)")
            }
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        try? coreDataManager?.mainContext.save()
    }
    
    // MARK: - Main

    func presentMainUI() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let navigationController = mainStoryboard.instantiateInitialViewController() as? UINavigationController,
              let viewController = navigationController.topViewController as? ColorsViewController,
              let coreDataManager = coreDataManager else {
            return
        }
        
        viewController.colorManager = ColorManager(backgroundContext: coreDataManager.backgroundContext)
        viewController.mainContext = coreDataManager.mainContext
        window?.rootViewController = navigationController
    }
}

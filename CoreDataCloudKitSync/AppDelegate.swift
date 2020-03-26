//
//  AppDelegate.swift
//  CoreDataCloudKitSync
//
//  Created by Isha Dua on 21/03/20.
//  Copyright © 2020 Isha Dua. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        let taskVC = TaskViewController(context: persistentContainer.viewContext)
        let mainNav = UINavigationController(rootViewController: taskVC)
        self.window = window
        self.window?.rootViewController = mainNav
        self.window?.makeKeyAndVisible()
        return true
    }


    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
            let container = NSPersistentCloudKitContainer(name: "CoreDataCloudKitSync")

            let ck = CKContainer.init(identifier: "CoreDataCloudKitSync")
            ck.accountStatus { (accountStatus, error) in
                print(accountStatus.rawValue)
                // Handle account status errors here
            }
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    print(error.localizedDescription)
                }
                
                // get the store description
               guard let description = container.persistentStoreDescriptions.first else {
                   fatalError("Could not retrieve a persistent store description.")
               }
               
               description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
             })
        
            
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        

            
            /// Initialize the CloudKit schema only for first time or when the schema is changed
//            try? container.initializeCloudKitSchema()

            return container
        }()
        

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


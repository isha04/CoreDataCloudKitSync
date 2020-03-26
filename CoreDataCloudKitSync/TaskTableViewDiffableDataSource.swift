////
////  TaskTableViewDiffableDataSource.swift
////  CoreDataCloudKitSync
////
////  Created by Isha Dua on 21/03/20.
////  Copyright © 2020 Isha Dua. All rights reserved.
////


import UIKit
import CoreData

/// Had to subclass diffable datasource to provide swipe to delete support

class TaskTableViewDiffableDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let identifierToDelete = itemIdentifier(for: indexPath) {
                //Delete the item from the managedObject context
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let task = managedContext.object(with: identifierToDelete)
                    managedContext.delete(task)
                    do {
                        try managedContext.save()
                    } catch {
                        print("Something went wrong while deletion")
                    }
                }
            }
        }
    }
}

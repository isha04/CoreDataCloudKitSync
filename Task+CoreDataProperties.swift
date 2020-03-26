//
//  Task+CoreDataProperties.swift
//  CoreDataCloudKitSync
//
//  Created by Isha Dua on 21/03/20.
//  Copyright © 2020 Isha Dua. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskDescription: String?
    @NSManaged public var taskTitle: String?

}

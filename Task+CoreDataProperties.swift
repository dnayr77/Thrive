//
//  Task+CoreDataProperties.swift
//  Thrive
//
//  Created by Ryan Dunn on 10/6/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

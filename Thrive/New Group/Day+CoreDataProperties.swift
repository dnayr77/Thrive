//
//  Day+CoreDataProperties.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/30/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var dayDate: Date?
    @NSManaged public var activity: NSSet?
    @NSManaged public var complete: NSSet?
    @NSManaged public var incomplete: NSSet?
    
    public var wrappedDate: Date {
        dayDate ?? Date()
    }

    public var dayComponents: DateComponents {
        Calendar.current.dateComponents([.day, .year, .month], from: dayDate ?? Date())
    }

    public var activityArray: [Activity] {
        let set = activity as? Set<Activity> ?? []
        return set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
    }
    
    public var completedArray: [Activity] {
        let set = complete as? Set<Activity> ?? []
        return set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
    }
    
    public var incompleteArray: [Activity] {
        let set = incomplete as? Set<Activity> ?? []
        return set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
    }
    
    public func makeAllComplete() {
        let set = activity as? Set<Activity> ?? []
        for entity in set {
            entity.makeComplete()
        }
    }
    
    public func makeAllIncomplete() {
        let set = activity as? Set<Activity> ?? []
        for entity in set {
            entity.makeIncomplete()
        }
    }

}

// MARK: Generated accessors for activity
extension Day {

    @objc(addActivityObject:)
    @NSManaged public func addToActivity(_ value: Activity)

    @objc(removeActivityObject:)
    @NSManaged public func removeFromActivity(_ value: Activity)

    @objc(addActivity:)
    @NSManaged public func addToActivity(_ values: NSSet)

    @objc(removeActivity:)
    @NSManaged public func removeFromActivity(_ values: NSSet)

}

// MARK: Generated accessors for complete
extension Day {

    @objc(addCompleteObject:)
    @NSManaged public func addToComplete(_ value: Activity)

    @objc(removeCompleteObject:)
    @NSManaged public func removeFromComplete(_ value: Activity)

    @objc(addComplete:)
    @NSManaged public func addToComplete(_ values: NSSet)

    @objc(removeComplete:)
    @NSManaged public func removeFromComplete(_ values: NSSet)

}

// MARK: Generated accessors for incomplete
extension Day {

    @objc(addIncompleteObject:)
    @NSManaged public func addToIncomplete(_ value: Activity)

    @objc(removeIncompleteObject:)
    @NSManaged public func removeFromIncomplete(_ value: Activity)

    @objc(addIncomplete:)
    @NSManaged public func addToIncomplete(_ values: NSSet)

    @objc(removeIncomplete:)
    @NSManaged public func removeFromIncomplete(_ values: NSSet)

}

extension Day : Identifiable {

}

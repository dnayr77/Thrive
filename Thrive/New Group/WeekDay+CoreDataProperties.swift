//
//  WeekDay+CoreDataProperties.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/30/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//
//

import Foundation
import CoreData


extension WeekDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeekDay> {
        return NSFetchRequest<WeekDay>(entityName: "WeekDay")
    }

    @NSManaged public var dayOfWeek: String?
    @NSManaged public var intOfWeek: Int16
    @NSManaged public var recurring: NSSet?
    @NSManaged public var complete: NSSet?
    @NSManaged public var incomplete: NSSet?
    @NSManaged public var dayActivity: NSSet?
    
    public var dayOfInt: Int {
        switch dayOfWeek {
        case "sunday":
            return 1
        case "monday":
            return 2
        case "tuesday":
            return 3
        case "wednesday":
            return 4
        case "thursday":
            return 5
        case "friday":
            return 6
        case "saturday":
            return 7
        default:
            return 8
        }
    }

    public var unwrappedDayOfWeek: String {
        return dayOfWeek ?? "error"
    }
    
    public var formattedDayOfWeek: String {
        let currentDayOfWeek = Calendar.current.component(.weekday, from: Date())
        if dayOfInt == currentDayOfWeek {
            return "Today"
        }
        else if  dayOfInt == (((currentDayOfWeek - 1) % 7) + 1) {
            return "Tomorrow"
        }
        else {
            return unwrappedDayOfWeek.upperFirstLetter()
        }
    }

    public var recurringArray: [Activity] {
        let set = recurring as? Set<Activity> ?? []
        return set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
    }
    
    public var completedArray: [Activity] {
        let set = complete as? Set<Activity> ?? []
        return set.sorted {
            $0.wrappedTime < $1.wrappedTime
        }
    }
    
    public var incompleteArray: [Activity] {
        let set = incomplete as? Set<Activity> ?? []
        return set.sorted {
            $0.wrappedTime < $1.wrappedTime
        }
    }

    public func resetStatus() {
        let set = recurring as? Set<Activity> ?? []
        for entity in set {
            entity.makeIncomplete(dayIndex: dayOfInt)
        }
    }
    
    public func makeAllComplete() {
        let set = recurring as? Set<Activity> ?? []
        for entity in set {
            entity.makeComplete(dayIndex: dayOfInt)
        }
    }
    
    public func makeAllIncomplete() {
        let set = recurring as? Set<Activity> ?? []
        for entity in set {
            entity.makeIncomplete(dayIndex: dayOfInt)
        }
    }


}

// MARK: Generated accessors for recurring
extension WeekDay {

    @objc(addRecurringObject:)
    @NSManaged public func addToRecurring(_ value: Activity)

    @objc(removeRecurringObject:)
    @NSManaged public func removeFromRecurring(_ value: Activity)

    @objc(addRecurring:)
    @NSManaged public func addToRecurring(_ values: NSSet)

    @objc(removeRecurring:)
    @NSManaged public func removeFromRecurring(_ values: NSSet)

}

// MARK: Generated accessors for complete
extension WeekDay {

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
extension WeekDay {

    @objc(addIncompleteObject:)
    @NSManaged public func addToIncomplete(_ value: Activity)

    @objc(removeIncompleteObject:)
    @NSManaged public func removeFromIncomplete(_ value: Activity)

    @objc(addIncomplete:)
    @NSManaged public func addToIncomplete(_ values: NSSet)

    @objc(removeIncomplete:)
    @NSManaged public func removeFromIncomplete(_ values: NSSet)

}

// MARK: Generated accessors for dayActivity
extension WeekDay {

    @objc(addDayActivityObject:)
    @NSManaged public func addToDayActivity(_ value: Activity)

    @objc(removeDayActivityObject:)
    @NSManaged public func removeFromDayActivity(_ value: Activity)

    @objc(addDayActivity:)
    @NSManaged public func addToDayActivity(_ values: NSSet)

    @objc(removeDayActivity:)
    @NSManaged public func removeFromDayActivity(_ values: NSSet)

}

extension WeekDay : Identifiable {

}

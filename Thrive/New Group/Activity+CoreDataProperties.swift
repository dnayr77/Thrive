//
//  Activity+CoreDataProperties.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/30/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isRec: Bool
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var type: String?
    @NSManaged public var dayComplete: Day?
    @NSManaged public var dayIncomplete: Day?
    @NSManaged public var dayOf: Day?
    @NSManaged public var activityWeekDay: WeekDay?
    @NSManaged public var complete: NSSet?
    @NSManaged public var incomplete: NSSet?
    @NSManaged public var recurring: NSSet?
    
    public var wrappedName: String {
        name ?? "An Activity"
    }

    public var wrappedDate: Date {
        date ?? Date()
    }
    
    public var wrappedTime: Date {
        (date ?? Date()).stripDate()
    }

    public var recurringArray: [WeekDay] {
        let set = recurring as? Set<WeekDay> ?? []
        return set.sorted {
            $0.dayOfInt < $1.dayOfInt
        }
    }

    public func isComplete() -> Bool {
        //return true if there is a completed relation between day entity
        return (dayComplete != nil)
    }

    public func isComplete(dayIndex: Int) -> Bool {
        let set = complete as? Set<WeekDay> ?? []
        let setSorted = set.sorted { $0.dayOfInt < $1.dayOfInt }
       
        //return true if there is a completed relation between the days recurring entitiy
        return (setSorted.filter{ $0.dayOfInt == dayIndex }.count > 0)
    }
    
    public func makeComplete(dayIndex: Int) {
        print("make rec complete")
        if isRec == true {
            print("one")
            let set = incomplete as? Set<WeekDay> ?? []
            let setSorted = set.sorted { $0.dayOfInt < $1.dayOfInt }
            if (setSorted.filter{ $0.dayOfInt == dayIndex }.count > 0) {
                addToComplete(setSorted.filter{ $0.dayOfInt == dayIndex }[0])
                removeFromIncomplete(setSorted.filter{ $0.dayOfInt == dayIndex }[0])
            }
        }
    }
    
    public func makeIncomplete(dayIndex: Int) {
        if isRec == true {
            let set = complete as? Set<WeekDay> ?? []
            let setSorted = set.sorted { $0.dayOfInt < $1.dayOfInt }
            if (setSorted.filter{ $0.dayOfInt == dayIndex }.count > 0) {
                addToIncomplete(setSorted.filter{ $0.dayOfInt == dayIndex }[0])
                removeFromComplete(setSorted.filter{ $0.dayOfInt == dayIndex }[0])
            }
        }
    }
    
    public func makeComplete() {
        //let dayIndex = (activityWeekDay ?? WeekDay()).dayOfInt
        print("make complete")
        if isRec == false {
            print("two")
            if dayIncomplete != nil{
                print("three")
                dayComplete = dayIncomplete
                dayIncomplete = nil
            }
            //let set = incomplete as? Set<WeekDay> ?? []
            //let setSorted = set.sorted { $0.dayOfInt < $1.dayOfInt }
            //if (setSorted.filter{ $0.dayOfInt == dayIndex }.count > 0) {
            //    addToComplete(setSorted.filter{ $0.dayOfInt == dayIndex }[0])
            //    removeFromIncomplete(setSorted.filter{ $0.dayOfInt == dayIndex }[0])
            //}
            if activityWeekDay != nil {
                print("four")
                addToComplete(activityWeekDay ?? WeekDay())
                removeFromIncomplete(activityWeekDay ?? WeekDay())
            }
        }
    }
    
    public func makeIncomplete() {
        if isRec == false {
            if dayComplete != nil{
                dayIncomplete = dayComplete
                dayComplete = nil
            }
            if activityWeekDay != nil {
                removeFromComplete(activityWeekDay ?? WeekDay())
                addToIncomplete(activityWeekDay ?? WeekDay())
            }
        }
    }
}

// MARK: Generated accessors for complete
extension Activity {

    @objc(addCompleteObject:)
    @NSManaged public func addToComplete(_ value: WeekDay)

    @objc(removeCompleteObject:)
    @NSManaged public func removeFromComplete(_ value: WeekDay)

    @objc(addComplete:)
    @NSManaged public func addToComplete(_ values: NSSet)

    @objc(removeComplete:)
    @NSManaged public func removeFromComplete(_ values: NSSet)

}

// MARK: Generated accessors for incomplete
extension Activity {

    @objc(addIncompleteObject:)
    @NSManaged public func addToIncomplete(_ value: WeekDay)

    @objc(removeIncompleteObject:)
    @NSManaged public func removeFromIncomplete(_ value: WeekDay)

    @objc(addIncomplete:)
    @NSManaged public func addToIncomplete(_ values: NSSet)

    @objc(removeIncomplete:)
    @NSManaged public func removeFromIncomplete(_ values: NSSet)

}

// MARK: Generated accessors for recurring
extension Activity {

    @objc(addRecurringObject:)
    @NSManaged public func addToRecurring(_ value: WeekDay)

    @objc(removeRecurringObject:)
    @NSManaged public func removeFromRecurring(_ value: WeekDay)

    @objc(addRecurring:)
    @NSManaged public func addToRecurring(_ values: NSSet)

    @objc(removeRecurring:)
    @NSManaged public func removeFromRecurring(_ values: NSSet)

}

extension Activity : Identifiable {

}

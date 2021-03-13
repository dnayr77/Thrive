//
//  Sample.swift
//  Thrive
//
//  Created by Ryan Dunn on 12/1/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI
import CoreData

//func list

class SampleModel {
    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        let today = Date()
        for indexOfWeek in 1...7 {
            let activityDate = (Calendar.current.date(byAdding: .day, value: indexOfWeek-1, to: today)!)
            for indexOfTime in 0...2 {
                let newActivity = Activity(context: context)
                let day = Day(context: context)
                let weekDay = WeekDay(context: context)
                let activityModTime = (Calendar.current.date(byAdding: .hour, value: (indexOfTime * 2)-1, to: activityDate)!)
                
                day.dayDate = activityDate.stripTime()
                
                weekDay.dayOfWeek = getDayOfWeek(index: indexOfWeek)
                weekDay.intOfWeek = Int16(indexOfWeek)
                
                newActivity.date = activityModTime
                newActivity.isRec = false
                newActivity.name = "Test " + String(indexOfTime) + " " + String(indexOfWeek)
                newActivity.type = "task"
                newActivity.dayOf = day
                newActivity.addToIncomplete(weekDay)
                newActivity.activityWeekDay = weekDay
                newActivity.dayIncomplete = day
            }
        }
        for num in 1...3 {
            let newActivity = Activity(context: context)
            newActivity.name = "Test Rec " + String(num)
            newActivity.type = "task"
            newActivity.isRec = true
            newActivity.date = (Calendar.current.date(byAdding: .day, value: num-1, to: today)!).stripDate()
            for index in 1...7 {
                let recurring = WeekDay(context: context)
                recurring.dayOfWeek = getDayOfWeek(index: index)
                recurring.intOfWeek = Int16(index)
                newActivity.addToRecurring(recurring)
                newActivity.addToIncomplete(recurring)
            }
        }
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func sampleActivities(nonRecCount: Int, recCount: Int) -> [Activity] {
        let today = Date()
        let dayOfWeek = Calendar.current.component(.weekday, from: Date())
        var list: [Activity] = []
        for num in 1...nonRecCount {
            let newActivity = Activity(context: context)
            let day = Day(context: context)
            let weekDay = WeekDay(context: context)
            day.dayDate = (Calendar.current.date(byAdding: .day, value: num-1, to: today)!).stripTime()
            weekDay.dayOfWeek = getDayOfWeek(index: ((dayOfWeek + num - 1)%7 + 1))
            weekDay.intOfWeek = Int16(num)
            newActivity.date = (Calendar.current.date(byAdding: .day, value: num-1, to: today)!).stripTime()
            newActivity.isRec = false
            newActivity.name = "test " + String(num)
            newActivity.type = "task"
            newActivity.dayOf = day
            newActivity.addToIncomplete(weekDay)
            newActivity.dayIncomplete = day
            list.append(newActivity)
        }
        for num in 1...recCount {
            let newActivity = Activity(context: context)
            newActivity.name = "Test Rec " + String(num)
            newActivity.type = "task"
            newActivity.isRec = true
            newActivity.date = (Calendar.current.date(byAdding: .day, value: num-1, to: today)!).stripDate()
            for index in 1...7 {
                let recurring = WeekDay(context: context)
                recurring.dayOfWeek = getDayOfWeek(index: index)
                recurring.intOfWeek = Int16(index)
                newActivity.addToRecurring(recurring)
                newActivity.addToIncomplete(recurring)
            }
            list.append(newActivity)
        }
        return list
    }
}

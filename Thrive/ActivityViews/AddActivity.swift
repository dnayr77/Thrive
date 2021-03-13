//
//  AddActivity.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/13/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct AddActivity: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    static let DefaultActivityName = "An untitled activity"

    @State var name = ""
    @State var activityDate = Date()
    @State var activityTime = Date()
    @State var recurringSelected = false
    @State var days = [false, false, false, false, false, false, false]
    let type: String
    let title: String

    let onComplete: (String, Date, Bool, [Bool]) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(title + " Name")) {
                    TextField(title + " Name", text: $name)
                }
                
                Section {
                    Toggle(isOn: $recurringSelected) {
                        Text("Recurring")
                    }
                }
                if !recurringSelected {
                    Section {
                        VStack {
                    
                            DatePicker(
                                selection: $activityDate,
                                displayedComponents: .date)
                                    {
                                        Text(title + " Date").foregroundColor(Color(.gray))
                                    }
                        
                        }
                    }
                } else {
                    Section {
                        VStack {
                            HStack {
                                Button(action: {
                                    days[1].toggle()
                                }) {
                                    Text("Mon")
                                }
                                .buttonStyle(DayButtonStyle(selection: days[1]))
                                Spacer()
                                Button(action: {
                                    days[2].toggle()
                                }) {
                                    Text("Tues")
                                }
                                .buttonStyle(DayButtonStyle(selection: days[2]))
                                Spacer()
                                Button(action: {
                                    days[3].toggle()
                                }) {
                                    Text("Wed")
                                }
                                .buttonStyle(DayButtonStyle(selection: days[3]))
                                Spacer()
                                Button(action: {
                                    days[4].toggle()
                                }) {
                                    Text("Thur")
                                }
                                .buttonStyle(DayButtonStyle(selection: days[4]))
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    days[5].toggle()
                                }) {
                                    Text("Fri")
                                }
                                .buttonStyle(DayButtonStyle(selection: days[5]))
                                Spacer()
                                Button(action: {
                                    days[6].toggle()
                                }) {
                                    Text("Sat")
                                }
                                .buttonStyle(DayButtonStyle(selection: days[6]))
                                Spacer()
                                Button(action: {
                                    days[0].toggle()
                                }) {
                                    Text("Sun")
                                }
                                .buttonStyle(DayButtonStyle(selection: days[0]))
                                Spacer()
                            }
                        }
                    }
                }
                
                

                Section {
                    DatePicker(
                        selection: $activityDate,
                        displayedComponents: .hourAndMinute) {
                            Text(title + " Time").foregroundColor(Color(.gray))
                    }
                }

                Section {
                    Button(action: addActivityAction) {
                        Text("Add " + title)
                    }
                }
            }
            .navigationBarTitle(Text("Add " + title), displayMode: .inline)
        }
    }
    
    private func addActivityAction() { onComplete(
        name.isEmpty ? AddActivity.DefaultActivityName : name,
        activityDate, recurringSelected, days)
    }
}

struct AddActivityButton: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showAddAction = false
    @State var activeSheet: ActiveSheet?

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.showAddAction.toggle()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(Font.system(size:45, weight: .light))
                        .background(
                              Color.white.mask(Circle())
                                .padding(5)
                            )
                })
                .padding(.bottom, 15)
                .padding(.trailing, 15)
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .task:
                AddActivity(type: "task", title: "Task") { name, activityDate, recurringSelected, days in
                    self.addActivity(name: name, date: activityDate, type: "task", isRecurring: recurringSelected, days: days)
                    self.activeSheet = nil
                }
            case .goal:
                AddActivity(type: "goal", title: "Goal") { name, activityDate, recurringSelected, days in
                    self.addActivity(name: name, date: activityDate, type: "goal", isRecurring: recurringSelected, days: days)
                    self.activeSheet = nil
                }
            case .project:
                AddActivity(type: "project", title: "Project") { name, activityDate, recurringSelected, days in
                    self.addActivity(name: name, date: activityDate, type: "project", isRecurring: recurringSelected, days: days)
                    self.activeSheet = nil
                }
            case .event:
                AddActivity(type: "event", title: "Event") { name, activityDate, recurringSelected, days in
                    self.addActivity(name: name, date: activityDate, type: "event", isRecurring: recurringSelected, days: days)
                    self.activeSheet = nil
                }
            }
        }
            
        .actionSheet(isPresented: $showAddAction) {
            ActionSheet(title: Text("Add a Task, Goal, Project or Event"), message: Text("Select an Option"), buttons: [
                .default(Text("Task")) { self.activeSheet = .task },
                .default(Text("Goal")) { self.activeSheet = .goal },
                .default(Text("Project")) { self.activeSheet = .project },
                .default(Text("Event")) { self.activeSheet = .event },
                .cancel()
            ])
        }
    }
    
    func addActivity(name: String, date: Date, type: String, isRecurring: Bool, days: [Bool]) {
        let newActivity = Activity(context: managedObjectContext)
        newActivity.name = name
        newActivity.type = type
        if isRecurring {
            newActivity.isRec = true
            newActivity.date = date.stripDate()
            let count = 0..<days.count
            for index in count {
                if days[index] {
                    let recurring = WeekDay(context: managedObjectContext)
                    recurring.dayOfWeek = getDayOfWeek(index: index + 1)
                    recurring.intOfWeek = Int16(index + 1)
                    newActivity.addToRecurring(recurring)
                    newActivity.addToIncomplete(recurring)
                }
            }
        }
        else {
            let day = Day(context: managedObjectContext)
            let weekDay = WeekDay(context: managedObjectContext)
            day.dayDate = date.stripTime()
            weekDay.dayOfWeek = getDayOfWeek(index: Calendar.current.component(.weekday, from: date))
            weekDay.intOfWeek = Int16(Calendar.current.component(.weekday, from: date))
            newActivity.isRec = false
            newActivity.date = date
            newActivity.dayOf = day
            newActivity.activityWeekDay = weekDay
            newActivity.addToIncomplete(weekDay)
            newActivity.dayIncomplete = day
        }
        saveContext()
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }

}

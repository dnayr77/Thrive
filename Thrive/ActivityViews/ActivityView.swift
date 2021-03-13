//
//  ActivityView.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/13/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
      entity: Activity.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Activity.date, ascending: false)
      ]
    )var activities: FetchedResults<Activity>
    
    let type: String
    
    var body: some View {
        let title = type.upperFirstLetter()
        VStack (alignment: .leading, spacing: 0) {
            NavigationView {
                List {
                    ForEach(activities, id: \.name) {
                        if $0.type == type {
                            ActivityCardView(activity: $0)
                        }
                    }
                    .onDelete(perform: deleteActivity)
                }
                
            .navigationBarTitle(Text(title + "s"))
            }
        }
    }
    
    func deleteActivity(at offsets: IndexSet) {
        offsets.forEach { index in
        let activity = self.activities[index]
        self.managedObjectContext.delete(activity)
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



// Display all of the activies for a given day
struct ActivityDayView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
      entity: Activity.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Activity.date, ascending: false)
      ]
    )var activities: FetchedResults<Activity>
    
    let day: Day
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(getDateFormatted(dayDate: Calendar.current.date(from: day.dayComponents) ?? Date()))
                .font(.title2)
                .padding(.leading, 5)
            Text("incomplete")
            ForEach(day.activityArray, id: \.name) { activity in
                ActivityCardView(activity: activity)
            }
            Text("incomplete")
            ForEach(day.incompleteArray, id: \.name) { activity in
                ActivityCardView(activity: activity)
            }
            Text("complete")
            ForEach(day.completedArray, id: \.name) { activity in
                ActivityCardView(activity: activity)
            }
            Text("all activities")
            ForEach(activities, id: \.name) { activity in
                ActivityCardView(activity: activity)
            }
                
        }
        .padding(.bottom, 3)
        .padding(.top, 10)
        .padding(.leading, 5)
        .padding(.trailing, 5)
        .background(
            Rectangle()
            .fill(Color(UIColor.secondarySystemBackground))
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(10))
        .padding(.bottom, 5)
        .animation(.linear(duration: 0.2))
    }

    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}




struct ActivityCardView: View {
    @State private var typeWidth = 50.0
    @State private var typeColor = Color.blue
    @State private var showDetail = false
    @State private var isExpand = false
    @State var flipped = false
    @State private var animate3d = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let activity: Activity
    
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
        formatter.dateStyle = .full
      return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    var body: some View {
        VStack {
            DisclosureGroup(
                isExpanded: $isExpand,
                content: {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showDetail.toggle()
                    }) {
                        Text("View")
                        .font(Font.system(size: 20, weight: .medium))
                            .padding(5)
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    Text("|")
                    Button(action: {
                        self.activity.makeComplete()
                        saveContext()
                    }) {
                        Text("Complete")
                        .font(Font.system(size: 20, weight: .medium))
                            .padding(5)
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                }
                .padding(.top, 15)
            
            }, label:  {
                HStack {
                    ActivityTypeView(activity: self.activity)
                    activity.name.map(Text.init)
                        .font(.system(size: 20))
                    Spacer()
                    activity.date.map { Text(Self.timeFormatter.string(from: $0)) }
                        .font(.system(size: 20))
                }
                .foregroundColor(Color(UIColor.label))
                .contentShape(Rectangle())
                .onTapGesture {
                    self.isExpand.toggle()
                }
            })
        }
        .padding(10)
        .background(
            Rectangle()
            .fill(Color(UIColor.secondarySystemFill))
                .frame(maxWidth: .infinity, alignment: .center)
            .shadow(color: .black, radius: 20, x: 0, y: 4)
            .cornerRadius(8))
        .sheet(isPresented: $showDetail) { ShowActivity(activity: self.activity) }
    }
    
    func deleteActivity() {
        self.managedObjectContext.delete(activity)
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

struct RecurringCardView: View {
    @State private var typeWidth = 50.0
    @State private var typeColor = Color.blue
    @State private var showDetail = false
    @State private var isExpand = false
    @State var flipped = false
    @State private var animate3d = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let activity: Activity
    let dayRec: Int
    
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
        formatter.dateStyle = .full
      return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    var body: some View {
        VStack {
            DisclosureGroup(
                isExpanded: $isExpand,
                content: {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showDetail.toggle()
                    }) {
                        Text("View")
                        .font(Font.system(size: 20, weight: .medium))
                            .padding(5)
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    Text("|")
                    Button(action: {
                        activity.makeComplete(dayIndex: dayRec)
                        saveContext()
                    }) {
                        Text("Complete")
                            .font(Font.system(size: 20, weight: .medium))
                            .padding(5)
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                }
                .padding(.top, 15)
            
            }, label:  {
                HStack {
                    ActivityTypeView(activity: self.activity)
                    activity.name.map(Text.init)
                        .font(.system(size: 20))
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        activity.date.map { Text(Self.timeFormatter.string(from: $0)) }
                            .font(.system(size: 20))
                        HStack(spacing: 0) {
                            ForEach(activity.recurringArray, id: \.dayOfWeek) { recurring in
                                Text( recurring.unwrappedDayOfWeek.prefix(1).capitalized )
                                    .font(.caption)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                }
                .foregroundColor(Color(UIColor.label))
                .contentShape(Rectangle())
                .onTapGesture {
                    self.isExpand.toggle()
                }
                
            })
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.top, 5)
        .padding(.bottom, 5)
        .background(
            Rectangle()
            .fill(Color(UIColor.secondarySystemFill))
                .frame(maxWidth: .infinity, alignment: .center)
            .shadow(color: .black, radius: 20, x: 0, y: 4)
            .cornerRadius(8))
        .sheet(isPresented: $showDetail) { ShowActivity(activity: self.activity) }
    }
    
    func deleteActivity() {
        self.managedObjectContext.delete(activity)
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


struct ActivityTypeView: View {
    let activity: Activity
    
    var body: some View {
        let type = (activity.type ?? "error")
        
        Text(type.upperFirstLetter())
            .background(
                Rectangle()
                .fill(self.labelColor(type: type))
                .frame(width: self.labelWidth(type: type), height: 25)
                .shadow(color: .black, radius: 20, x: 0, y: 4)
                .cornerRadius(8))
            .padding(.leading, 5)
            .padding(.trailing, 5)
    }
    
    func labelWidth(type: String) -> CGFloat {
        switch type {
        case "task":
            return CGFloat(50)
        case "project":
            return CGFloat(70)
        case "goal":
            return CGFloat(50)
        case "event":
            return CGFloat(60)
        default:
            return CGFloat(50)
        }
    }
        
    func labelColor(type: String) -> Color {
        switch type {
        case "task":
            return Color.blue
        case "project":
            return Color.green
        case "goal":
            return Color.yellow
        case "event":
            return Color.gray
        default:
            return Color.gray
        }
    }
}



struct ShowActivity: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var selectedDate: Date
    @State var name: String
    @State var isEdit = false
    static let DefaultActivityName = "An untitled activity"
    let activity: Activity
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var closedRange: ClosedRange<Date> {
            let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
            let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
            
            return fiveDaysAgo...twoDaysAgo
        }

    var body: some View {
        let activityDate = (activity.date ?? Date())
        let activityName = (activity.name ?? "Activity Name")
        let title = (activity.type ?? "error").upperFirstLetter()
        let dateRange = activityDate ... activityDate
        
        
        NavigationView {
            Form {
                
                if isEdit {
                    Section(header: Text("Edit " + title + " Name")) {
                        TextField(activityName, text: $name)
                    }
                }
                
                if isEdit {
                    Section {
                        DatePicker(
                            selection: $selectedDate,
                            displayedComponents: .hourAndMinute) {
                                Text("Edit " + title + " Time").foregroundColor(Color(.gray))
                        }
                    }
                }
                
                else {
                    Section {
                        activity.date.map { Text(Self.timeFormatter.string(from: $0)) }
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section {
                    if #available(iOS 14.0, *) {
                        if isEdit {
                            DatePicker(
                                " Date",
                                selection: $selectedDate,
                                displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        } else {
                            DatePicker(
                                " Date",
                                selection: $selectedDate,
                                in: dateRange,
                                displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                                
                    } else {
                        DatePicker(
                            selection: $selectedDate,
                            displayedComponents: .date)
                                {
                                    Text(title + " Date").foregroundColor(Color(.gray))
                                }
                    }
                }
                
                if isEdit {
                    Section {
                        Button(action: {
                            isEdit.toggle()
                            activity.date = selectedDate
                            activity.name = name
                        }){
                            Text("Save Changes")
                        }
                    }
                } else {
                    Section {
                        HStack {
                        Button(action: {
                            deleteActivity()
                        }){
                            Text("Delete " + title)
                        }
                        Spacer()
                        Button(action: {
                            isEdit.toggle()
                        }){
                            Text("Edit " + title)
                        }
                        }
                    }
                }
            
            }
            .navigationBarTitle(Text(activity.name ?? "error"), displayMode: .inline)
        }

    }
    
    init(activity: Activity) {

        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.darkGray,
            .font : UIFont(name: "HelveticaNeue-Thin", size: 30)!]
        self.activity = activity
        _selectedDate = State(initialValue: activity.date ?? Date())
        _name = State(initialValue: activity.name ?? "Task")
    }
    
    func deleteActivity() {
        self.managedObjectContext.delete(activity)
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

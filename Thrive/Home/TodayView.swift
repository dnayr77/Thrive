//
//  TodayView.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/30/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct TodayView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let weekDays: FetchedResults<WeekDay>
    
    let timeFormatter: DateFormatter = {
      let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
      return formatter
    }()
    
    var body: some View {
        HomeWrapperView(title: "Today") {
            let currentTime = Date().stripDate()
            let dayOfWeek = Calendar.current.component(.weekday, from: Date())
            ForEach(self.weekDays.filter { $0.dayOfInt == dayOfWeek}, id: \.self) { today in
                ActivitySectionView(title: "Incomplete", activities: today.incompleteArray.filter{ $0.wrappedTime < currentTime }, dayOfWeek: today.dayOfInt, isEdit: true)
                ActivitySectionView(title: "Upcoming", activities: today.incompleteArray.filter{ $0.wrappedTime >= currentTime }, dayOfWeek: today.dayOfInt, isEdit: true)
                ActivitySectionView(title: "Completed", activities: today.completedArray, dayOfWeek: today.dayOfInt)
                
                if today.incompleteArray.count == 0 {
                    VStack {
                        Text("All of todays activities have been completed!")
                            .padding(.top, 5)
                            .padding(.leading, 5)
                        HStack { Spacer() }
                    }
                    .modifier(ActivitySectionStyle())
                }
                else if today.incompleteArray.count == 0 {
                    VStack {
                        Text("You have no activities today")
                            .padding(.top, 5)
                            .padding(.leading, 5)
                        HStack { Spacer() }
                    }
                    .modifier(ActivitySectionStyle())
                }
                VStack {
                    EmptyView()
                }
                .padding(.bottom, 110)
            }
            
        }
    }
}

struct ActivityTodayView: View {
    //@State private var isWeekDay = false
    //@State private var isDay = false
    @State private var todayDate = Date().stripTime()
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var sessionData: SessionData
    @FetchRequest(
      entity: Day.entity(),
      sortDescriptors: [NSSortDescriptor(keyPath: \Day.dayDate, ascending: true)],
        predicate: NSPredicate(format: "dayDate == %@", Date().stripTime() as NSDate)
    )var days: FetchedResults<Day>
    
    @FetchRequest(
        entity: WeekDay.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WeekDay.dayOfWeek, ascending: true)],
        predicate: NSPredicate(format: "dayOfWeek == %@", getDayOfWeek(index: Calendar.current.component(.weekday, from: Date())) )
    )var weekDays: FetchedResults<WeekDay>
    
    var body: some View {
        let currentTime = Date().stripDate()
        let dayOfWeek = Calendar.current.component(.weekday, from: Date())
        ForEach(self.sessionData.weekDays!.filter { $0.dayOfInt == dayOfWeek}, id: \.self) { today in
            ActivitySectionView(title: "Incomplete", activities: today.incompleteArray.filter{ $0.wrappedTime < currentTime }, dayOfWeek: today.dayOfInt, isEdit: true)
            ActivitySectionView(title: "Upcoming", activities: today.incompleteArray.filter{ $0.wrappedTime >= currentTime }, dayOfWeek: today.dayOfInt, isEdit: true)
            ActivitySectionView(title: "Completed", activities: today.completedArray, dayOfWeek: today.dayOfInt)
            
            if today.incompleteArray.count == 0 {
                VStack {
                    Text("All of todays activities have been completed!")
                        .padding(.top, 5)
                        .padding(.leading, 5)
                    HStack { Spacer() }
                }
                .modifier(ActivitySectionStyle())
            }
            else if today.incompleteArray.count == 0 {
                VStack {
                    Text("You have no activities today")
                        .padding(.top, 5)
                        .padding(.leading, 5)
                    HStack { Spacer() }
                }
                .modifier(ActivitySectionStyle())
            }
            VStack {
                EmptyView()
            }
            .padding(.bottom, 110)
        }
        
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}


struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        //let context = (UIApplication.shared.delegate as! SceneDelegate).persistentContainer.viewContext
        //let newData = SampleModel(context: context)
        EmptyView()
        //TodayView().environment(\.managedObjectContext, context)
    }
}

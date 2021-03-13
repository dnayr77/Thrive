//
//  ContentView.swift
//  Thrive
//
//  Created by Ryan Dunn on 9/11/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import Combine
import SwiftUI

enum ActiveSheet: Identifiable {
    case task, goal, project, event
    
    var id: Int {
        hashValue
    }
}

struct ContentView: View {
    @State private var backgroundColor = Color.white
    @State private var selection = 0
    @State private var prevSelection = 0
    @State private var isShowingSettings = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var sessionInfo: SessionInfo
    
   
    
    @FetchRequest(
      entity: Activity.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Activity.name, ascending: true)
      ]
    ) var activities: FetchedResults<Activity>
    
    @FetchRequest(
      entity: WeekDay.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \WeekDay.dayOfWeek, ascending: true)
      ]
    )var weekDays: FetchedResults<WeekDay>
    
    @FetchRequest(
      entity: Day.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Day.dayDate, ascending: true)
      ]
    )var days: FetchedResults<Day>

    
    
    
    var body: some View {
        return NavigationView {
            TabView(selection: $selection){
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "house")
                                .font(Font.system(size: 25, weight: .bold))
                            Text("Home")
                        }
                    }
                    .tag(0)
                
                ProgressView()
                    .tabItem {
                        VStack {
                            Image(systemName: "checkmark.square")
                                .font(Font.system(size: 25, weight: .bold))
                            Text("Progress")
                        }
                    }
                    .tag(1)
                
                FeedView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person.2")
                            .font(Font.system(size: 25, weight: .bold))
                            Text("Feed")
                        }
                    }
                    .tag(2)
                    
                UserView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person.circle")
                            .font(Font.system(size: 25, weight: .bold))
                            Text("User")
                        }
                    }
                    .tag(3)
            }
            .onAppear {
                if sessionInfo.differentDay {
                    self.resetRecStatus()
                }
                if sessionInfo.firstLaunch {
                    self.initCoreData()
                }
            }
            
            .navigationBarTitle("Thrive", displayMode: .inline)
                
            .navigationBarItems(leading:
                HStack {
                    NavigationLink(destination: CalendarView()) {
                        Image(systemName: "calendar")
                        .font(Font.system(size: 20, weight: .medium))
                    }
                }, trailing:
                HStack {
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    }
                }
            )
        }
    }
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.darkGray,
            .font : UIFont(name: "HelveticaNeue-Thin", size: 25)!]
    }
    
    func initCoreData(){
        print("Init Core Data Called")
        if !sessionInfo.firstLaunch {
            return
        }
        //if sessionInfo.firstLaunch {
        //    let newData = SampleModel(context: managedObjectContext)
            //for index in 1...7 {
             //   print("Create weekday at index: " + String(index))
               // let weekDay = WeekDay(context: managedObjectContext)
               // weekDay.dayOfWeek = getDayOfWeek(index: index)
               // weekDay.intOfWeek = Int16(index)
            //}
        //    saveContext()
        //}
    }
    
    func exitSettings() {
        self.isShowingSettings = false
    }
    
    func resetRecStatus() {
        if weekDays.count == 0 {
            print("resetting for 0 days")
            //return EmptyView()
        }
        else if sessionInfo.daysSinceOpen == 7 {
            print("resetting for 7 days")
            for recur in weekDays {
                recur.resetStatus()
            }
        }
        else {
            print("resetting for multiple days")
            var dayOfWeek = Calendar.current.component(.weekday, from: Date())
            for _ in 1...sessionInfo.daysSinceOpen {
                dayOfWeek -= 1
                if dayOfWeek <= 0 {
                    dayOfWeek = 7
                    if (weekDays.filter{ $0.dayOfInt == dayOfWeek }.count > 0) {
                        weekDays.filter{ $0.dayOfInt == dayOfWeek }[0].resetStatus();
                    }
                }
                else {
                    if (weekDays.filter{ $0.dayOfInt == dayOfWeek }.count > 0) {
                        weekDays.filter{ $0.dayOfInt == dayOfWeek }[0].resetStatus()
                    }
                }
            }
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

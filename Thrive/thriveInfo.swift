//
//  thriveInfo.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/25/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

class SessionInfo: ObservableObject {
    //@State var homeViews = ["recView": [1, "true"], "recView": [1, "true"], "recView": [1, "true"], "recView": [1, "true"], "recView": [1, "true"]]
    
    struct HomeViewType: Hashable {
        var shown: Bool? = nil
        var name: String
        var index: Int? = nil
        init(name: String, shown: Bool? = nil, index: Int? = nil) {
            self.name = name
            self.shown = shown ?? false
            self.index = index ?? 10
        }
        
        mutating func updateShown(shown: Bool) {
            self.shown = shown
            UserDefaults.standard.set(shown, forKey: (self.name + "Shown"))
        }
        mutating func updateIndex(index: Int) {
            self.index = index
            UserDefaults.standard.set(index, forKey: (self.name + "Index"))
        }
    }
    
    init() {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let todayString = String(formatter1.string(from: Date()))
        homeViews = []
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            UserDefaults.standard.set(todayString, forKey: "dayOfWeek")
            UserDefaults.standard.set(Date().stripTime(), forKey: "dateLastOpened")
            currentPage = "onboardingView"
            firstLaunch = true
            differentDay = false
            daysSinceOpen = 0
            setDefaultHomeViews()
        } else {
            currentPage = "contentView"
            firstLaunch = false
            if  UserDefaults.standard.string(forKey: "dayOfWeek") != todayString {
                UserDefaults.standard.set(todayString, forKey: "dayOfWeek")
                let prevDate = UserDefaults.standard.object(forKey: "dateLastOpened") as! Date
                let dayDiff = Calendar.current.dateComponents([.year, .month, .day], from: prevDate, to: Date().stripTime())
                
                if dayDiff.year! > 0 || dayDiff.month! > 0 || dayDiff.day! > 6 {
                    daysSinceOpen = 7
                }
                else {
                    daysSinceOpen = dayDiff.day!
                }
                differentDay = true
                UserDefaults.standard.set(Date().stripTime(), forKey: "dateLastOpened")
            } else {
                differentDay = false
                daysSinceOpen = 0
            }
            reloadHomeViews()
        }
        
    }
    
    func setDefaultHomeViews() {
        for index in 0..<homeViewNames.count {
            if index < 3 {
                self.homeViews.append(HomeViewType(name: homeViewNames[index], shown: true , index: index))
                UserDefaults.standard.set(true, forKey: (homeViewNames[index] + "Shown"))
                UserDefaults.standard.set(index, forKey: (homeViewNames[index] + "Index"))
            }
            else {
                UserDefaults.standard.set(false, forKey: (homeViewNames[index] + "Shown"))
                UserDefaults.standard.set(index, forKey: (homeViewNames[index] + "Index"))
            }
        }
        UserDefaults.standard.set(3, forKey: "activeHomeViews")
    }
    
    func reloadHomeViews() {
        var tempHomeViews: [HomeViewType] = []
        for name in self.homeViewNames {
            let shown = UserDefaults.standard.bool(forKey: (name + "Shown"))
            let index = UserDefaults.standard.integer(forKey: (name + "Index"))
            if shown {
                tempHomeViews.append(HomeViewType(name: name, shown: shown, index: index))
            }
        }
        homeViews = tempHomeViews.sorted { $0.index! < $1.index! }
    }
    
    public var homeShowCount: Int {
        return homeViews.count
    }
    
    func updateHomeViews(shownArray: [Bool]) {
        for index in 0..<homeViews.count {
            homeViews[index].updateShown(shown: shownArray[index])
            UserDefaults.standard.set(shownArray[index], forKey: (homeViews[index].name + "Shown"))
        }
    }
    
    public var homeNotShown: [String] {
        var result: [String] = []
        for name in homeViewNames {
            if !UserDefaults.standard.bool(forKey: (name + "Shown")) {
                result.append(name)
            }
        }
        return result
    }
    
    func addHomeView(name: String) {
        let index = homeViews.count
        homeViews.append(HomeViewType(name: name, shown: true, index: index))
        UserDefaults.standard.set(index, forKey: (name + "Index"))
        UserDefaults.standard.set(true, forKey: (name + "Shown"))
    }
    
    func updateHomeViews() {
        for name in self.homeViewNames {
            UserDefaults.standard.set(0, forKey: (name + "Index"))
            UserDefaults.standard.set(false, forKey: (name + "Shown"))
        }
        for index in 0..<homeViews.count {
            let name = homeViews[index].name
            homeViews[index].updateIndex(index: index)
            UserDefaults.standard.set(index, forKey: (name + "Index"))
            UserDefaults.standard.set(true, forKey: (name + "Shown"))
        }
    }
    
    @Published var homeViewNames = ["Today View", "Week View", "Upcoming View", "Past View", "All Activities View", "Recurring View"]
    @Published var homeViews: [HomeViewType]
    @Published var currentPage: String
    @Published var firstLaunch: Bool
    @Published var differentDay: Bool
    @Published var daysSinceOpen: Int
    
}

class SessionData: ObservableObject {
    @Published var days: FetchedResults<Day>?
    @Published var weekDays: FetchedResults<WeekDay>? = nil
    @Published var activities: FetchedResults<Activity>? = nil
}

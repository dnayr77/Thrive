//
//  HomeView.swift
//  Thrive
//
//  Created by Ryan Dunn on 9/16/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI


struct HomeView: View {
    @State private var currentPage = 0
    @EnvironmentObject var sessionInfo: SessionInfo
    @Environment(\.managedObjectContext) var managedObjectContext
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
        ZStack {
            PagerView(pageCount: sessionInfo.homeShowCount, currentIndex: $currentPage) {
                ForEach(sessionInfo.homeViews, id: \.self) { view in
                    if view.shown ?? false {
                        if view.name == sessionInfo.homeViewNames[0] {
                            TodayView(weekDays: self.weekDays)
                        }
                        if view.name == sessionInfo.homeViewNames[1] {
                            WeekView(weekDays: self.weekDays)
                        }
                        if view.name == sessionInfo.homeViewNames[2] {
                            UpcomingView(activities: self.activities, days: self.days)
                        }
                        if view.name == sessionInfo.homeViewNames[3] {
                            PastView(days: self.days)
                        }
                        if view.name == sessionInfo.homeViewNames[4] {
                            AllActivityView(activities: self.activities, days: self.days)
                        }
                        if view.name == sessionInfo.homeViewNames[5] {
                            RecurringView(weekDays: self.weekDays)
                        }
                    }
                }
            }
            AddActivityButton()
        }
    }
}

struct HomeWrapperView<Content: View>: View {
    let content: Content
    var title: String? = nil

    init(title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.title = title ?? "Activities"
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { g in
                VStack(alignment: .leading) {
                    Text(self.title!)
                            .font(Font.system(size: g.size.height/3 + g.frame(in: .global).minY/5, weight: .medium))
                            .offset(y: -g.frame(in: .global).minY/2+60)
                }
            }
            .frame(height: 60)
            content
        }
        .padding(.leading, 5)
        .padding(.trailing, 5)
    }
}





struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  WeekView.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/30/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct WeekView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let weekDays: FetchedResults<WeekDay>
    
    let timeFormatter: DateFormatter = {
      let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
      return formatter
    }()
    
    var body: some View {
        HomeWrapperView(title: "This Week")  {
            let currentDayOfWeek = Calendar.current.component(.weekday, from: Date())
            ForEach(0..<7) { index in
                let dayOfWeek = ((currentDayOfWeek + index - 1 ) % 7) + 1
                
                ForEach(self.weekDays.filter { $0.dayOfInt == dayOfWeek}, id: \.self) { day in
                    ActivitySectionView(title: day.formattedDayOfWeek, activities: day.incompleteArray, dayOfWeek: dayOfWeek, hideRec: true)
                }
            }
            VStack {
                EmptyView()
            }
            .padding(.bottom, 110)
        }
    }
}

struct ActivityWeekView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: WeekDay.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WeekDay.dayOfWeek, ascending: true)]
    )var weekDays: FetchedResults<WeekDay>
    
    let columns = [
        GridItem(.flexible())
    ]
    var body: some View {
        let currentDayOfWeek = Calendar.current.component(.weekday, from: Date())
        LazyVGrid (columns: columns) {
            ForEach(0..<7) { index in
                let dayOfWeek = ((currentDayOfWeek + index - 1 ) % 7) + 1
                //let dayOfWeek = index
                let day = weekDays.filter{ $0.dayOfInt == dayOfWeek }
                if day.count > 0 {
                    ActivitySectionView(title: day[0].formattedDayOfWeek, activities: day[0].incompleteArray, dayOfWeek: dayOfWeek)
                }
                else {
                    VStack {
                        Text(getDayOfWeek(index: dayOfWeek))
                            .font(.title)
                            .padding(.leading, 5)
                        Text("You have no activities today")
                            .padding(.top, 5)
                            .padding(.leading, 5)
                        HStack { Spacer() }
                    }
                    .modifier(ActivitySectionStyle())
                }
            }
            VStack {
                EmptyView()
            }
            .padding(.bottom, 110)
        }
    }
}


struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        //WeekView()
        EmptyView()
    }
}

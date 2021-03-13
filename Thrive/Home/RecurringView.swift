//
//  WeekDayView.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/23/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct RecurringView: View {
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
                    ActivitySectionView(title: day.formattedDayOfWeek, activities: day.incompleteArray, dayOfWeek: dayOfWeek, onlyRec: true)
                }
            }
            VStack {
                EmptyView()
            }
            .padding(.bottom, 110)
        }
    }
}


struct RecurringView_Previews: PreviewProvider {
    static var previews: some View {
        //RecurringView()
        EmptyView()
    }
}

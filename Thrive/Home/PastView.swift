//
//  PastView.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/25/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct PastView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let days: FetchedResults<Day>
    
    var body: some View {
        let todayDate = Date().stripTime()
        HomeWrapperView(title: "Past")  {
            ForEach(days.sorted{ $0.wrappedDate > $1.wrappedDate}, id: \.self) { day in
                if day.wrappedDate < todayDate {
                    ActivitySectionView(title: getDateFormatted(dayDate: day.dayDate ?? Date()), activities: day.activityArray, dayOfWeek: 0)
                }
            }
        }
    }
}


struct PastView_Previews: PreviewProvider {
    static var previews: some View {
        //PastView()
        EmptyView()
    }
}

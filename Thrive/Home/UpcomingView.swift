//
//  UpcomingView.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/23/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct UpcomingView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let activities: FetchedResults<Activity>
    let days: FetchedResults<Day>
    
    var body: some View {
        let todayDate = Date().stripTime()
        let recurring = activities.filter{ $0.isRec == true }
        HomeWrapperView(title: "All Activities")  {
            ForEach(days, id: \.self) { day in
                if day.wrappedDate < todayDate {
                    ActivitySectionView(title: getDateFormatted(dayDate: day.dayDate ?? Date()), activities: day.incompleteArray, dayOfWeek: 0)
                }
            }
            ActivitySectionView(title: "Recurring", activities: recurring, dayOfWeek: 0)
            
            ForEach(days, id: \.self) { day in
                if day.wrappedDate >= todayDate {
                    ActivitySectionView(title: getDateFormatted(dayDate: day.dayDate ?? Date()), activities: day.incompleteArray, dayOfWeek: 0)
                }
            }
        }
    }
}

struct UpcomingView_Previews: PreviewProvider {
    static var previews: some View {
        //UpcomingView()
        EmptyView()
    }
}

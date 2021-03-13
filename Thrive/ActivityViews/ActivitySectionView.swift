//
//  ActivitySectionView.swift
//  Thrive
//
//  Created by Ryan Dunn on 12/1/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct ActivitySectionView: View {
    
    var title: String? = nil
    var activities: [Activity]? = nil
    var dayOfWeek: Int? = nil
    var isEdit: Bool? = nil
    var showEmpty: Bool? = nil
    var hideRec: Bool? = nil
    var onlyRec: Bool? = nil
    var notRec: Bool? = nil
    
    init(title: String? = nil, activities: [Activity]? = nil, dayOfWeek: Int? = nil, isEdit: Bool? = nil, showEmpty: Bool? = nil, hideRec: Bool? = nil, onlyRec: Bool? = nil, notRec: Bool? = nil) {
        self.title = title
        self.activities = activities ?? []
        self.dayOfWeek = dayOfWeek ?? 1
        self.isEdit = isEdit ?? false
        self.showEmpty = showEmpty ?? false
        self.hideRec = hideRec ?? false
        self.onlyRec = onlyRec ?? false
        self.notRec = notRec ?? false
        
    }
    
    var body: some View {
        if showEmpty == true || (self.activities!.count > 0) {
            VStack(alignment: .leading) {
                HStack {
                    if title != nil {
                        Text(title!)
                            .font(.title)
                            .padding(.leading, 5)
                    }
                
                    if isEdit! {
                        Spacer()
                        Text("Complete")
                    }
                }
                if self.hideRec == true {
                    HideRecSectionView(activities: self.activities!, dayOfWeek: self.dayOfWeek!)
                }
                else {
                    SectionShowActivityView(activities: self.activities!, dayOfWeek: self.dayOfWeek!, onlyRec: self.onlyRec!, notRec: self.notRec!)
                }
                if activities!.count == 0 {
                    HStack {
                        Spacer()
                    }
                    HStack {
                        Text("No activities today")
                    }
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
        else {
            EmptyView()
        }
    }
}

struct SectionShowActivityView: View {
    let activities: [Activity]
    let dayOfWeek: Int
    let onlyRec: Bool
    let notRec: Bool
    
    var body: some View {
        if onlyRec {
            ForEach(activities.filter{ $0.isRec == true }, id: \.name) { activity in
                ActivityCardView(activity: activity)
            }
        }
        else if notRec {
            ForEach(activities.filter{ $0.isRec == false }, id: \.name) { activity in
                ActivityCardView(activity: activity)
            }
        }
        else {
            ForEach(activities, id: \.name) { activity in
                if activity.isRec {
                    RecurringCardView(activity: activity, dayRec: dayOfWeek)
                }
                else {
                    ActivityCardView(activity: activity)
                }
            }
        }
    }
}


struct HideRecSectionView: View {
    @State private var isExpand = false
    @State private var recTitle = "Show Recurring"
    let activities: [Activity]
    let dayOfWeek: Int
    
    var body: some View {
        ForEach(activities.filter { $0.isRec == true }, id: \.name) { activity in
            ActivityCardView(activity: activity)
        }
        if (activities.filter{ $0.isRec == true }.count > 0) {
            VStack {
                DisclosureGroup(
                    isExpanded: $isExpand,
                    content: {
                        Divider()
                        ForEach(activities.filter { $0.isRec == true }, id: \.name) { activity in
                            RecurringCardView(activity: activity, dayRec: dayOfWeek)
                        }
                }, label:  {
                    HStack {
                        Spacer()
                        Text(self.recTitle)
                        Spacer()
                    }
                    .foregroundColor(Color(UIColor.label))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.isExpand.toggle()
                        if self.recTitle == "Show Recurring" {
                            self.recTitle = "Hide Recurring"
                        }
                        else {
                            self.recTitle = "Show Recurring"
                        }
                    }
                })
            }
        }
    }
}

struct ActivitySectionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! SceneDelegate).persistentContainer.viewContext
        let newData = SampleModel(context: context)
        ActivitySectionView(title: "Test", activities: newData.sampleActivities(nonRecCount: 2, recCount: 2), dayOfWeek: Calendar.current.component(.weekday, from: Date())).environment(\.managedObjectContext, context)
    }
}

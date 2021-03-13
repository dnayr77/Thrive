//
//  FilteredActivity.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/28/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import CoreData
import SwiftUI

struct FilteredActivity<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var activities: FetchedResults<T> { fetchRequest.wrappedValue }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }

    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
}

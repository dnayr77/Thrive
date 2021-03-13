//
//  FeedView.swift
//  Thrive
//
//  Created by Ryan Dunn on 9/16/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct FeedView: View {
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: Text("Second View"), tag: "Second", selection: $selection) { EmptyView() }
                NavigationLink(destination: Text("Third View"), tag: "Third", selection: $selection) { EmptyView() }
                Button("Tap to show second") {
                    self.selection = "Second"
                }
                Button("Tap to show third") {
                    self.selection = "Third"
                }
            }
            .navigationBarTitle("Navigation")
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

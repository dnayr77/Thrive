//
//  ElementStyle.swift
//  Thrive
//
//  Created by Ryan Dunn on 12/1/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct ActivitySectionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
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
}


//
//  ButtonStyle.swift
//  Thrive
//
//  Created by Ryan Dunn on 12/1/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct DayButtonStyle: ButtonStyle {
    let selection: Bool
    func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding()
      .foregroundColor(.white)
      .background(selection ? Color.red : Color.blue)
      .cornerRadius(8)
    }
}


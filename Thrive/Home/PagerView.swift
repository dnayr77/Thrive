//
//  PagerView.swift
//  Thrive
//
//  Created by Ryan Dunn on 12/3/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
        PageControl(index: $currentIndex, maxIndex: pageCount - 1)
    }
}

struct PageControl: View {
    @Binding var index: Int
    let maxIndex: Int

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 8) {
                ForEach(0...maxIndex, id: \.self) { index in
                    Circle()
                        .fill(index == self.index ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(15)
        }
    }
}

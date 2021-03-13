//
//  Functions.swift
//  Thrive
//
//  Created by Ryan Dunn on 11/13/20.
//  Copyright © 2020 Ryan Dunn. All rights reserved.
//

import SwiftUI

extension String {
    func upperFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func upperFirstLetter() {
        self = self.upperFirstLetter()
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    func stripDate() -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}

extension View {

      func flipRotate(_ degrees : Double) -> some View {
            return rotation3DEffect(Angle(degrees: degrees), axis: (x: 1.0, y: 0.0, z: 0.0))
      }      
}

func getDateFormatted(dayDate: Date) -> String {
    let timeFormatter: DateFormatter = {
      let formatter = DateFormatter()
        formatter.dateStyle = .medium
      return formatter
    }()
    let calendar = Calendar.current
    let today = Calendar.current.dateComponents([.day, .year, .month], from: Date())
    if calendar.isDateInTomorrow(dayDate){
        return "Tomorrow"
    }
    else if Calendar.current.dateComponents([.day, .year, .month], from: dayDate) == today {
        return "Today"
    }
    else if calendar.isDateInYesterday(dayDate) {
        return "Yesterday"
    } else {
        return timeFormatter.string(from: dayDate)
    }
}

func dayHasActivities(days: FetchedResults<Day>) -> Bool {
    if days.count == 0 {
        return false
    }
    else if days[0].activityArray.count == 0 {
        return false
    }
    else {
        return true
    }
}

func dayHasIncomplete(days: FetchedResults<Day>) -> Bool {
    if days.count == 0 {
        return false
    }
    else if days[0].incompleteArray.count == 0 {
        return false
    }
    else {
        return true
    }
}

func recHasActivities(days: FetchedResults<WeekDay>) -> Bool {
    if days.count == 0 {
        return false
    }
    else if days[0].recurringArray.count == 0 {
        return false
    }
    else {
        return true
    }
}

func weekDayHasIncomplete(days: FetchedResults<WeekDay>) -> Bool {
    if days.count == 0 {
        return false
    }
    else if days[0].incompleteArray.count == 0 {
        return false
    }
    else {
        return true
    }
}

func getAllIncomplete(recurring: FetchedResults<WeekDay>, days: FetchedResults<Day>) -> [Activity] {
    if days.count == 0 {
        if recurring.count > 0 {
            return recurring[0].incompleteArray
        }
        else {
            return []
        }
    }
    else if recurring.count == 0 {
        return days[0].incompleteArray
    }
    else {
        let set = recurring[0].incompleteArray + days[0].incompleteArray
        let sortSet = set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
        return sortSet
    }
}

func getDayOfWeek(index: Int) -> String {
    switch index {
    case 1:
        return "sunday"
    case 2:
        return "monday"
    case 3:
        return "tuesday"
    case 4:
        return "wednesday"
    case 5:
        return "thursday"
    case 6:
        return "friday"
    case 7:
        return "saturday"
    default:
        return "monday"
    }
}



struct FlipEffect: GeometryEffect {

      var animatableData: Double {
            get { angle }
            set { angle = newValue }
      }

      @Binding var flipped: Bool
      var angle: Double
      let axis: (x: CGFloat, y: CGFloat)

      func effectValue(size: CGSize) -> ProjectionTransform {

            DispatchQueue.main.async {
                  self.flipped = self.angle >= 90 && self.angle < 270
            }

            let tweakedAngle = flipped ? -180 + angle : angle
            let a = CGFloat(Angle(degrees: tweakedAngle).radians)

            var transform3d = CATransform3DIdentity;
            transform3d.m34 = -1/max(size.width, size.height)

            transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}



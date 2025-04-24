//
//  Date.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/23/25.
//

import Foundation

extension Date {
    func startOfDay(in timeZone: TimeZone = TimeZone(identifier: "Asia/Seoul")!) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = timeZone

        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }

    func isSameDay(as date: Date, in timeZone: TimeZone = TimeZone(identifier: "Asia/Seoul")!) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        return calendar.isDate(self, inSameDayAs: date)
    }
}

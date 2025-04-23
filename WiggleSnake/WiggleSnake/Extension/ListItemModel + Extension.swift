//
//  ListItemModel + Extension.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/21/25.
//

import Foundation

// MARK: DataRange를 구하기 위한 extension
extension ListItemModel {
    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        
        let now = Date()
        let calendar = Calendar.current
        
        let daysSinceStart = calendar.dateComponents([.day], from: startDate, to: now).day ?? 0
        
        if calendar.isDateInToday(startDate) {
            return "데일리 도전!"
        } else if calendar.isDateInToday(endDate) {
            return "마지막 날! 놓치지 마세요!"
        } else if daysSinceStart == 0 {
            return "\(start)~\(end)" // 시작일 ~ 종료일로만 표시
        } else {
            return "도전 \(daysSinceStart + 1)일차!"
        }
    }
}



//
//  Date.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/17/25.
//

import Foundation

extension DateFormatter {
    static let koreanShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        formatter.dateFormat = "M월 d일" // 원하는 포맷
        formatter.timeZone = .current
        return formatter
    }()
    
    
}

// MARK: DataRange를 구하기 위한 extension
extension ListItemModel {
    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return "\(formatter.string(from: startDate))~\(formatter.string(from: endDate))"
    }
}

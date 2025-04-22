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
        return "\(formatter.string(from: startDate))~\(formatter.string(from: endDate))"
    }
}

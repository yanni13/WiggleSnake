//
//  ListItemModel.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import Foundation

struct ListItemModel: Identifiable, Equatable, Hashable {
    let id: UUID
    var category: CategoryIcon
    var title: String
    var startDate: Date
    var endDate: Date
    var memo: String
    var isCompleted: Bool
    var completedDate: Date?
    var dataRange: String
    
    // 오늘 완료한 도전인지 확인
    var isCompletedToday: Bool {
            guard let completedDate else { return false }
            return Calendar.current.isDateInToday(completedDate)
        }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ListItemModel, rhs: ListItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

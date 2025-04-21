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
    var dataRange: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ListItemModel, rhs: ListItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

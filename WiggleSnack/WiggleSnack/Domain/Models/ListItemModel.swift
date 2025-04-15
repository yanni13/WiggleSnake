//
//  ListItemModel.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import Foundation

struct ListItemModel: Identifiable {
    let id = UUID()
    let category: CategoryIcon
    let title: String
    let dateRange: String
    var isCompleted: Bool
}

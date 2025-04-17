//
//  ChallengeItem.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/17/25.
//

import Foundation

extension Challenge {
    func toListItemModel() -> ListItemModel? {
        guard let id = id,
              let title = title,
              let startDate = startDate,
              let endDate = endDate,
              let memo = memo,
              let categoryRaw = category,
              let category = CategoryIcon(rawValue: categoryRaw) else {
            return nil
        }
                
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M/d"
                let range = "\(dateFormatter.string(from: startDate)) ~ \(dateFormatter.string(from: endDate))"
                
                return ListItemModel(
                    id: id,
                    category: category,
                    title: title,
                    startDate: startDate,
                    endDate: endDate,
                    memo: memo,
                    isCompleted: isCompleted,
                    dataRange: range
                )
    }
    
}

//
//  Challenge + Extension.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/21/25.
//

import CoreData

extension Challenge {
    func toChallengeRecordModels() -> [ChallengeRecordModel] {
        guard let recordSet = self.records as? Set<ChallengeRecord> else {
            print("🚨 Challenge.records가 비어있거나 형변환 실패")
            return []
        }

        return recordSet.map { record in
            ChallengeRecordModel(
                id: record.id ?? UUID(),
                date: record.date ?? Date(),
                isCompleted: record.isCompleted
            )
        }
    }
}

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


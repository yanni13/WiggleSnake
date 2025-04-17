//
//  FetchChallengeViewModel.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/17/25.
//

import Foundation
import CoreData

final class FetchChallengeViewModel: ObservableObject {
    @Published var items: [ListItemModel] = []

    /// 데이터 조회
    func fetchAllChallenges(context: NSManagedObjectContext) -> [ListItemModel] {

        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        do {
            let result = try context.fetch(request)
            return result.compactMap { $0.toListItemModel() }
        } catch {
            print("CoreData fetch error: \(error)")
            return []
        }
    }
}

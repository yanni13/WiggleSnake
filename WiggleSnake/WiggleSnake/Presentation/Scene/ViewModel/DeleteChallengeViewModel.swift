//
//  DeleteChallengeViewModel.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/21/25.
//

import Foundation
import CoreData

final class DeleteChallengeViewModel: ObservableObject {
    @Published var items: [ListItemModel] = []
    
    /// 데이터 삭제
    func deleteChallenge(for item: ListItemModel, context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let challenge = results.first {
                context.delete(challenge)
                try context.save()
                completion(true)
                print("🗑️ Challenge가 삭제되었습니다.")
            } else {
                completion(false)
                print("⚠️ 해당 ID에 해당하는 Challenge를 찾을 수 없습니다.")
            }
        } catch {
            completion(false)
            print("❌ CoreData 삭제 실패: \(error)")
        }
    }

}

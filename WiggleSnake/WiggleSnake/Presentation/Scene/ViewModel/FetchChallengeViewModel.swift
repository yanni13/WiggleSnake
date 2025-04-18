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
        
        do {
            let challenges = try context.fetch(request)
            

            print("🔍 불러온 Challenge 수: \(challenges.count)")
            
            for (index, challenge) in challenges.enumerated() {
                print("------ Challenge \(index + 1) ------")
                print("📝 제목: \(challenge.title ?? "없음")")
                print("📄 메모: \(challenge.memo ?? "없음")")
                print("📂 카테고리: \(challenge.category ?? "없음")")
                print("📅 시작일: \(challenge.startDate?.description ?? "없음")")
                print("📅 종료일: \(challenge.endDate?.description ?? "없음")")
            }
            items = challenges.compactMap { $0.toListItemModel()} // fetch
            
            return challenges.compactMap { $0.toListItemModel()}
        } catch {
            print("CoreData fetch error: \(error)")
            return []
        }
    }
    
    /// 데이터 수정 - 진행중인 데이터를 완료 데이터로 넘김
    func updateCompletion(for item: ListItemModel, context: NSManagedObjectContext) {
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let challenge = results.first {
                challenge.isCompleted = item.isCompleted
                try context.save()
                print("✅ isCompleted 상태가 CoreData에 반영되었습니다.")
            }
        } catch {
            print("❌ CoreData 업데이트 실패: \(error)")
        }
    }


}


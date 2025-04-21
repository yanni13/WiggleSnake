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
    @Published var completedDates: Set<Date> = [] // 완료된 날짜를 저장할 변수 추가
    
    
    /// 데이터 조회
    func fetchAllChallenges(context: NSManagedObjectContext) -> [ListItemModel] {
    let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
    request.relationshipKeyPathsForPrefetching = ["records"] 

    
    do {
        let challenges = try context.fetch(request)
        
        // Challenge 데이터를 ListItemModel로 변환
        self.items = challenges.compactMap { $0.toListItemModel() }
        
        self.completedDates = Set(challenges.flatMap { challenge in
            print("🌟 challenge: \(challenge.title ?? "No Title")")
            return challenge.toChallengeRecordModels().compactMap { record in
                print("➡️ Checking record: \(record.date) | isCompleted: \(record.isCompleted)")
                // 각 ChallengeRecord에서 isCompleted가 true인 날짜만 추출
                if record.isCompleted {
                    print("✅ Adding completed date: \(record.date.startOfDay())")
                    return record.date.startOfDay() // 날짜의 시간부분을 제거하여 비교하도록 변경
                } else {
                    return nil
                }
            }
        })
        
        
        
        return items
    } catch {
        print("CoreData fetch error: \(error)")
        return []
    }
        
}
//    func fetchAllChallenges(context: NSManagedObjectContext) -> [ListItemModel] {
//        
//        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
//        
//        // ChallengeRecord와의 관계를 포함시키기 위해
//        request.relationshipKeyPathsForPrefetching = ["challengeRecords"]
//        
//        do {
//            let challenges = try context.fetch(request)
//            
//            print("🔍 불러온 Challenge 수: \(challenges.count)")
//            
//            for (index, challenge) in challenges.enumerated() {
//                print("------ Challenge \(index + 1) ------")
//                print("📝 제목: \(challenge.title ?? "없음")")
//                print("📄 메모: \(challenge.memo ?? "없음")")
//                print("📂 카테고리: \(challenge.category ?? "없음")")
//                print("📅 시작일: \(challenge.startDate?.description ?? "없음")")
//                print("📅 종료일: \(challenge.endDate?.description ?? "없음")")
//            }
//            items = challenges.compactMap { $0.toListItemModel()} // fetch
//            
//            // 완료된 날짜 목록을 ChallengeRecord에서 가져오기
//            self.completedDates = Set(challenges.flatMap { challenge in
//                // ChallengeRecord에서 완료된 날짜들만 필터링
//                return challenge.records?.compactMap { record in
//                    // isCompleted가 true일 때만 date를 반환
//                    if record.isCompleted {
//                        return record.date
//                    } else {
//                        return nil
//                    }
//                } ?? []
//            })
//            
//            return challenges.compactMap { $0.toListItemModel()}
//        } catch {
//            print("CoreData fetch error: \(error)")
//            return []
//        }
//    }
    
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
    
    func refreshItem(context: NSManagedObjectContext) {
        self.items = fetchAllChallenges(context: context)
        self.objectWillChange.send()
    }
    
    /// 실제 도전을 수행한 기간이 얼만지 파악하기 위한 배열 추가 로직
    func markChallengeCompleted(for item: ListItemModel, on date: Date, context: NSManagedObjectContext) {
        // Challenge fetch
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            if let challenge = try context.fetch(request).first {
                let record = ChallengeRecord(context: context)
                record.id = UUID()
                record.date = date
                record.isCompleted = true
                record.challenge = challenge
                
                try context.save()
                print("✅ 저장된 기록: \(date)")
                
                // completedDates 갱신
                fetchCompletedDates(context: context)
            }
        } catch {
            print("❌ 저장 실패: \(error)")
        }
    }

    func fetchCompletedDates(context: NSManagedObjectContext) {
        let request: NSFetchRequest<ChallengeRecord> = ChallengeRecord.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
        
        do {
            let records = try context.fetch(request)
            let completed = Set(records.map { $0.date!.startOfDay() })
            self.completedDates = completed
            print("🎯 완료된 날짜들: \(completed)")
        } catch {
            print("❌ ChallengeRecord fetch 실패: \(error)")
        }
    }


}


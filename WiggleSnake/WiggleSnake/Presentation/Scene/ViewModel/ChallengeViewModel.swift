//
//  ChallengeViewModel.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/16/25.
//

import Foundation
import CoreData

final class ChallengeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var memo: String = ""
    @Published var category: CategoryIcon? = nil

//    @Published var category: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var isValidForm: Bool = false
    @Published var items: [ListItemModel] = []
    @Published var completedDates: Set<Date> = [] // 완료된 날짜를 저장할 변수 추가
    
    private var existingChallenge: Challenge?
    
    
    /// 도전기록 추가하기 입력폼의 유효성을 검사하는 함수
    func formValid(completion: @escaping (Bool) -> Void) {
        if let category = category, !title.isEmpty && !category.rawValue.isEmpty && startDate <= endDate {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    /// 데이터 저장
    func saveChallenge(context: NSManagedObjectContext) {
        if let existingChallenge {
            // 수정 모드
            existingChallenge.title = title
            existingChallenge.memo = memo
            existingChallenge.category = category?.rawValue ?? ""
            existingChallenge.startDate = startDate
            existingChallenge.endDate = endDate
            return
        } else {
            // 추가 모드
            let newChallenge = Challenge(context: context)
            newChallenge.id = UUID()
            newChallenge.title = title
            newChallenge.memo = memo
            newChallenge.category = category?.rawValue ?? ""
            newChallenge.startDate = startDate
            newChallenge.endDate = endDate
        }
        
        
        do {
            try context.save()
            print("✅[AddChallengeViewModel] 저장 성공")
            
            // 저장 후 바로 데이터 확인
            let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
            let challenges = try context.fetch(fetchRequest)
            print("저장된 Challenge 수: \(challenges.count)")
            
            // 방금 저장한 데이터 확인
            if let lastChallenge = challenges.last {
                print("마지막으로 저장된 Challenge:")
                print("제목: \(lastChallenge.title ?? "없음")")
                print("메모: \(lastChallenge.memo ?? "없음")")
            }
            
        } catch {
            print("❌[AddChallengeViewModel] 저장 실패: \(error)")
        }
    }
    
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
    
    /// 데이터 조회
    func fetchAllChallenges(context: NSManagedObjectContext) -> [ListItemModel] {
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.relationshipKeyPathsForPrefetching = ["records"]
        
        
        do {
            let challenges = try context.fetch(request)
            
            // Challenge 데이터를 ListItemModel로 변환
            self.items = challenges.compactMap { $0.toListItemModel() }
            
            self.completedDates = Set(challenges.flatMap { challenge in
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
    
    private func fetchCompletedDates(context: NSManagedObjectContext) {
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

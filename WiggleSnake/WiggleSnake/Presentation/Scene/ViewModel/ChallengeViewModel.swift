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
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var isValidForm: Bool = false
    @Published var items: [ListItemModel] = []
    @Published var completedDates: Set<Date> = [] // 완료된 날짜를 저장할 변수 추가
    @Published var editingItem: ListItemModel?
    @Published var updateTrigger: Bool = false
    private var existingChallenge: Challenge?
    
    
    /// 도전기록 추가하기 입력폼의 유효성을 검사하는 함수
    func formValid(completion: @escaping (Bool) -> Void) {
        if let category = category, !title.isEmpty && !category.rawValue.isEmpty && startDate <= endDate {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    // 특정 항목만 갱신하는 메서드
    func updateChallenge(_ updatedItem: ListItemModel, context: NSManagedObjectContext) {
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            items[index] = updatedItem
        }
    }
    
    /// 데이터 저장
    func saveChallenge(context: NSManagedObjectContext, mode: ChallengeEditorMode) {
        switch mode {
        case .add:
            let newChallenge = Challenge(context: context)
            newChallenge.id = UUID()
            newChallenge.title = self.title
            newChallenge.memo = self.memo
            newChallenge.startDate = self.startDate
            newChallenge.endDate = self.endDate
            newChallenge.category = self.category?.rawValue ?? ""
            
        case .edit:
            guard let existingChallenge = self.existingChallenge else {
                print("❌ existingChallenge가 nil입니다.")
                return
            }
            existingChallenge.title = self.title
            existingChallenge.memo = self.memo
            existingChallenge.startDate = self.startDate
            existingChallenge.endDate = self.endDate
            existingChallenge.category = self.category?.rawValue ?? ""
            
            updateTrigger = true
            
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

                    if record.isCompleted {
                        print("✅ Adding completed date: \(record.date.startOfDay())")
                        return record.date.startOfDay()
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
    
    /// 도전일지 수정하기에 사용하기 위해 데이터를 로드하고 편집하는 메서드
    func loadChallenge(from item: ListItemModel, context: NSManagedObjectContext) {
        // 특정 ID를 가진 Challenge 엔티티 가져오기
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        request.relationshipKeyPathsForPrefetching = ["records"] 
        
        do {
            if let challenge = try context.fetch(request).first {
                // existingChallenge 속성 설정
                self.existingChallenge = challenge
                
                self.title = challenge.title ?? ""
                self.memo = challenge.memo ?? ""
                if let categoryString = challenge.category, !categoryString.isEmpty {
                    self.category = CategoryIcon(rawValue: categoryString)
                }
                self.startDate = challenge.startDate ?? Date()
                self.endDate = challenge.endDate ?? Date()
                
                self.editingItem = item
                
                let records = challenge.toChallengeRecordModels()
                let completedDates = Set(records.compactMap { record in
                    return record.isCompleted ? record.date.startOfDay() : nil
                })
                self.completedDates = completedDates
                
                print("✅ Challenge 로딩 성공: \(challenge.title ?? "")")
            } else {
                print("⚠️ 해당 ID에 해당하는 Challenge를 찾을 수 없습니다.")
            }
        } catch {
            print("❌ Challenge 불러오기 실패: \(error)")
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

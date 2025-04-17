//
//  AddChallengeViewModel.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/16/25.
//

import Foundation
import CoreData

final class AddChallengeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var memo: String = ""
    @Published var category: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var isValidForm: Bool = false
    
    /// 도전기록 추가하기 입력폼의 유효성을 검사하는 함수
    func formValid(completion: @escaping (Bool) -> Void) {
        if !title.isEmpty && !category.isEmpty && startDate <= endDate {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func saveChallenge(context: NSManagedObjectContext) {
        let newChallenge = Challenge(context: context)
        newChallenge.id = UUID()
        newChallenge.title = title
        newChallenge.memo = memo
        newChallenge.category = category
        newChallenge.startDate = startDate
        newChallenge.endDate = endDate
        
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
    
    
}


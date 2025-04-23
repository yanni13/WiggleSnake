//
//  WormDataManager.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/23/25.
//

import Foundation

// 앱 전체에서 지렁이 데이터 공유를 위한 싱글톤
final class WormDataManager: ObservableObject {
    static let shared = WormDataManager()
    
    @Published var completedChallenges: Set<String> = []
    
    private init() {}
    
    func completeChallenge(_ challenge: String) {
        completedChallenges.insert(challenge)
        NotificationCenter.default.post(name: Notification.Name("ChallengeCompleted"), object: challenge)
    }
}

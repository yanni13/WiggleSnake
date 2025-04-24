//
//  WormViewModel.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/23/25.
//

import Foundation
import Combine
import SwiftUI

final class WormViewModel: ObservableObject {
    @Published var wormSegments: [CGPoint] = []
    @Published var listItems: [ListItemModel] = []
    
    private var movementTimer: AnyCancellable?
    private var direction: CGFloat = 0 // 각도로 방향 표현 (라디안)
    private var velocity: CGFloat = 3.0 // 속도
    private var bounds: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

    private var targetDirection: CGFloat = 0
    private var turnSpeed: CGFloat = 0.1
    
    // 경계에서 유지할 안전 거리
    private let safetyMargin: CGFloat = 10.0
    
    // 지렁이 세그먼트 사이 거리
    private let segmentDistance: CGFloat = 10.0
    
    // 도전당 길이 증가량 (10cm)
    private let growthPerChallenge: Int = 10
    // 기본 길이
    private let baseLength: Int = 10
    // 최대 길이 (화면 크기에 따라 조정됨)
    private var maxLength: Int = 1000

    func addListItem(_ item: ListItemModel) {
        listItems.append(item)
        resetWorm()
    }
    
    func updateListItem(_ item: ListItemModel) {
        if let index = listItems.firstIndex(where: { $0.id == item.id }) {
            listItems[index] = item
            resetWorm()
        }
    }
    
    func removeListItem(_ item: ListItemModel) {
        listItems.removeAll(where: { $0.id == item.id })
        resetWorm()
    }
    
    // 완료된 도전 수 계산
    private var completedChallengesCount: Int {
        return listItems.filter { $0.isCompleted }.count
    }

    func resetWorm() {
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        
        direction = 0
        wormSegments = []

        let segmentCount = max(1, completedChallengesCount)

        for i in 0..<segmentCount {
            let x = centerX - CGFloat(i) * segmentDistance
            wormSegments.append(CGPoint(x: x, y: centerY))
        }
    }

    
    // 지렁이 길이 계산 (기본 길이 + 완료된 도전당 추가 길이)
    private func calculateWormLength() -> Int {
        let length = baseLength + (completedChallengesCount * growthPerChallenge)
        return min(length, maxLength) // 최대 길이 제한
    }
    
    func startMoving() {
        movementTimer?.cancel()
        
        updateWormPosition()
        
        movementTimer = Timer.publish(every: 0.03, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateWormPosition()
            }
    }
    
    func updateWormPosition() {
        guard !wormSegments.isEmpty else { return }
        
        // 가끔 방향 변경 목표 설정
        if Int.random(in: 0...50) == 0 {
            targetDirection = direction + CGFloat.random(in: -1.0...1.0)
        }
        
        // 목표 방향으로 부드럽게 회전
        let angleDiff = angleDifference(targetDirection, direction)
        if abs(angleDiff) > 0.01 {
            direction += angleDiff * turnSpeed
        }
        
        // 경계에 닿으면 방향 변경 (안전 마진 고려)
        let head = wormSegments[0]
        
        // 경계 근처에서는 더 확실하게 회전하도록 방향 조정
        if head.x < bounds.minX + safetyMargin {
            // 왼쪽 경계에 가까우면 오른쪽으로 확실하게 회전
            let angle = CGFloat.random(in: -0.5...0.5) // 방향에 약간의 변화 추가
            targetDirection = angle // 오른쪽 방향 (0도 = 오른쪽)
            direction = targetDirection // 즉시 방향 변경
        }
        else if head.x > bounds.maxX - safetyMargin {
            // 오른쪽 경계에 가까우면 왼쪽으로 확실하게 회전
            let angle = CGFloat.random(in: -0.5...0.5) // 방향에 약간의 변화 추가
            targetDirection = .pi + angle // 왼쪽 방향 (180도 = 왼쪽)
            direction = targetDirection // 즉시 방향 변경
        }
        
        if head.y < bounds.minY + safetyMargin {
            // 위쪽 경계에 가까우면 아래쪽으로 확실하게 회전
            let angle = CGFloat.random(in: -0.5...0.5) // 방향에 약간의 변화 추가
            targetDirection = .pi/2 + angle // 아래쪽 방향 (90도 = 아래쪽)
            direction = targetDirection // 즉시 방향 변경
        }
        else if head.y > bounds.maxY - safetyMargin {
            // 아래쪽 경계에 가까우면 위쪽으로 확실하게 회전
            let angle = CGFloat.random(in: -0.5...0.5) // 방향에 약간의 변화 추가
            targetDirection = -.pi/2 + angle // 위쪽 방향 (-90도 = 위쪽)
            direction = targetDirection // 즉시 방향 변경
        }
        
        // 머리 위치 업데이트
        let dx = cos(direction) * velocity
        let dy = sin(direction) * velocity
        var newHead = CGPoint(x: head.x + dx, y: head.y + dy)
        
        // 화면 밖으로 나갔는지 확인하고, 나갔다면 화면 안으로 강제 이동
        newHead.x = max(bounds.minX + 5, min(bounds.maxX - 5, newHead.x))
        newHead.y = max(bounds.minY + 5, min(bounds.maxY - 5, newHead.y))
        
        // 새 머리 추가
        wormSegments.insert(newHead, at: 0)
        
        // 세그먼트 사이 거리 유지
        maintainSegmentDistances()
        
//        // 지렁이 길이 조절 - 계산된 길이로 유지
//        let desiredLength = calculateWormLength()
//        while wormSegments.count > desiredLength {
//            wormSegments.removeLast()
//        }
        // 실제 길이 기반으로 자르기
        let maxAllowedLength = calculateWormLength()
        while currentWormLength() > CGFloat(maxAllowedLength), wormSegments.count > 1 {
            wormSegments.removeLast()
        }

        
        objectWillChange.send()
    }
    
    // 세그먼트 사이 거리 유지하기
    private func maintainSegmentDistances() {
        guard wormSegments.count >= 2 else { return }
        
        var newSegments: [CGPoint] = [wormSegments[0]]
        
        for i in 1..<wormSegments.count {
            let prev = newSegments[i-1]
            let curr = wormSegments[i]
            
            let dx = curr.x - prev.x
            let dy = curr.y - prev.y
            let distance = sqrt(dx*dx + dy*dy)
            
            if distance > segmentDistance {
                // 이전 세그먼트 방향으로 현재 세그먼트 위치 조정
                let ratio = segmentDistance / distance
                let newX = prev.x + dx * ratio
                let newY = prev.y + dy * ratio
                newSegments.append(CGPoint(x: newX, y: newY))
            } else {
                newSegments.append(curr)
            }
        }
        
        wormSegments = newSegments
    }
    
    // 두 각도 사이의 최소 차이 계산 (-π ~ π 범위)
    private func angleDifference(_ angle1: CGFloat, _ angle2: CGFloat) -> CGFloat {
        var diff = (angle1 - angle2).truncatingRemainder(dividingBy: 2 * .pi)
        if diff > .pi {
            diff -= 2 * .pi
        } else if diff < -.pi {
            diff += 2 * .pi
        }
        return diff
    }
    
    func setBounds(_ newBounds: CGRect) {
        bounds = newBounds
        
        // 화면 크기에 맞게 최대 길이 조정
        // 화면을 가득 채울 수 있는 적절한 최대 길이 계산
        let maxViewDimension = max(newBounds.width, newBounds.height)
//        maxLength = Int(maxViewDimension / segmentDistance) * 2 // 화면을 두 번 돌 수 있는 정도의 길이
        maxLength = Int((newBounds.width + newBounds.height) * 1.5)

        
    }
    
    // 현재 지렁이의 전체 실제 길이 계산
    private func currentWormLength() -> CGFloat {
        guard wormSegments.count >= 2 else { return 0 }

        var totalLength: CGFloat = 0
        for i in 1..<wormSegments.count {
            let dx = wormSegments[i].x - wormSegments[i - 1].x
            let dy = wormSegments[i].y - wormSegments[i - 1].y
            totalLength += sqrt(dx*dx + dy*dy)
        }
        return totalLength
    }

}

import SwiftUI
import Combine

struct WormView: View {
    @StateObject private var viewModel = WormViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                
                ImprovedWormCanvas(segments: viewModel.wormSegments)
            }
            .onAppear {
                // 지렁이 크기와 영역 설정
                viewModel.setBounds(CGRect(x: 200, y: 0, width: geometry.size.width, height: geometry.size.height))
                viewModel.resetWorm()
            }
        }
        
        .clipped() // 화면 밖으로 나가는 부분 클리핑
        .border(.black)
    }
}


struct ImprovedWormCanvas: View {
    let segments: [CGPoint]
    
    var body: some View {
        Canvas { context, size in
            guard segments.count >= 2 else { return }
            
            // 지렁이 몸통을 부드러운 스플라인으로 그리기
            var path = Path()
            path.move(to: segments[0])
            
            // 베지어 커브를 사용해 부드러운 곡선 그리기
            if segments.count >= 3 {
                for i in 1..<segments.count-1 {
                    let p0 = segments[i-1]
                    let p1 = segments[i]
                    let p2 = segments[i+1]
                    
                    // 제어점 계산
                    let controlPoint1 = CGPoint(
                        x: p1.x - (p2.x - p0.x) * 0.2,
                        y: p1.y - (p2.y - p0.y) * 0.2
                    )
                    let controlPoint2 = CGPoint(
                        x: p1.x + (p2.x - p0.x) * 0.2,
                        y: p1.y + (p2.y - p0.y) * 0.2
                    )
                    
                    path.addCurve(to: p1, control1: controlPoint1, control2: controlPoint2)
                }
            } else {
                // 세그먼트가 적을 경우 라인으로 연결
                for i in 1..<segments.count {
                    path.addLine(to: segments[i])
                }
            }
            
            
            // 다양한 두께로 지렁이 그리기 (머리가 더 두껍게)
            for i in 0..<segments.count-1 {
                let startPoint = segments[i]
                let endPoint = segments[i+1]
                
                // 세그먼트마다 두께 계산 (머리에서 꼬리로 갈수록 얇아짐)
                let thickness = 18.0 * (1.0 - Double(i) / Double(segments.count) * 0.3)
                
                var segmentPath = Path()
                segmentPath.move(to: startPoint)
                segmentPath.addLine(to: endPoint)
                
                context.stroke(segmentPath, with: .color(.mint), style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
            }
            
            // 머리 부분 그리기
            if let head = segments.first {
                context.fill(Circle().path(in: CGRect(x: head.x - 5, y: head.y - 5, width: 10, height: 10)), with: .color(.black))
                
                // 눈 그리기
                let headDirection = CGVector(
                    dx: head.x - (segments.count > 1 ? segments[1].x : head.x),
                    dy: head.y - (segments.count > 1 ? segments[1].y : head.y)
                )
                
                let headAngle = atan2(headDirection.dy, headDirection.dx)
                let eyeOffset = CGPoint(
                    x: cos(headAngle) * 4,
                    y: sin(headAngle) * 4
                )
                
                let leftEyeOffset = CGPoint(
                    x: cos(headAngle + .pi/2) * 3,
                    y: sin(headAngle + .pi/2) * 3
                )
                
                let rightEyeOffset = CGPoint(
                    x: cos(headAngle - .pi/2) * 3,
                    y: sin(headAngle - .pi/2) * 3
                )
                
                // 왼쪽 눈
                context.fill(
                    Circle().path(in: CGRect(
                        x: head.x + eyeOffset.x + leftEyeOffset.x - 1.5,
                        y: head.y + eyeOffset.y + leftEyeOffset.y - 1.5,
                        width: 3,
                        height: 3
                    )),
                    with: .color(.white)
                )
                
                // 오른쪽 눈
                context.fill(
                    Circle().path(in: CGRect(
                        x: head.x + eyeOffset.x + rightEyeOffset.x - 1.5,
                        y: head.y + eyeOffset.y + rightEyeOffset.y - 1.5,
                        width: 3,
                        height: 3
                    )),
                    with: .color(.white)
                )
            }
        }
    }
}

class WormViewModel: ObservableObject {
    @Published var wormSegments: [CGPoint] = []
    @Published var completedChallenges: Set<String> = []
    private var movementTimer: AnyCancellable?
    private var direction: CGFloat = 0 // 각도로 방향 표현 (라디안)
    private var velocity: CGFloat = 3.0 // 속도
    private var bounds: CGRect = CGRect(x: 0, y: 0, width: 300, height: 400)
    private var targetDirection: CGFloat = 0
    private var turnSpeed: CGFloat = 0.1
    
    // 지렁이 세그먼트 사이 거리
    private let segmentDistance: CGFloat = 10.0
    
    init() {
        resetWorm()
        startMoving()
    }
    
    func resetWorm() {
        // 초기 지렁이 생성
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        
        // 초기 방향 (오른쪽)
        direction = 0
        
        // 초기 세그먼트 생성
        wormSegments = []
        let initialLength = 5 + completedChallenges.count * 3
        
        for i in 0..<initialLength {
            let x = centerX - CGFloat(i) * segmentDistance
            wormSegments.append(CGPoint(x: x, y: centerY))
        }
    }
    
    func startMoving() {
        movementTimer?.cancel()
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
        
        // 경계에 닿으면 방향 전환
        let head = wormSegments[0]
        if head.x < bounds.minX + 30 {
            targetDirection = 0 // 오른쪽으로
        } else if head.x > bounds.maxX - 30 {
            targetDirection = .pi // 왼쪽으로
        }
        
        if head.y < bounds.minY + 30 {
            targetDirection = .pi / 2 // 아래로
        } else if head.y > bounds.maxY - 30 {
            targetDirection = -.pi / 2 // 위로
        }
        
        // 머리 위치 업데이트
        let dx = cos(direction) * velocity
        let dy = sin(direction) * velocity
        let newHead = CGPoint(x: head.x + dx, y: head.y + dy)
        
        
        
        // 새 머리 추가
        wormSegments.insert(newHead, at: 0)
        
        // 세그먼트 사이 거리 유지
        maintainSegmentDistances()
        
        // 지렁이 길이 조절
        let desiredLength: Int = 200
//        let desiredLength = 5 + completedChallenges.count * 3
        while wormSegments.count > desiredLength {
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
    
    func completeChallenge(_ challenge: String) {
        completedChallenges.insert(challenge)
        objectWillChange.send()
    }
    
    func setBounds(_ newBounds: CGRect) {
        bounds = newBounds
    }
}

// 앱 전체에서 지렁이 데이터 공유를 위한 싱글톤
class WormDataManager: ObservableObject {
    static let shared = WormDataManager()
    
    @Published var completedChallenges: Set<String> = []
    
    private init() {}
    
    func completeChallenge(_ challenge: String) {
        completedChallenges.insert(challenge)
        NotificationCenter.default.post(name: Notification.Name("ChallengeCompleted"), object: challenge)
    }
}

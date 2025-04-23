import SwiftUI
import Combine

struct WormView: View {
    @StateObject private var viewModel = WormViewModel()
//    @Binding var listItems: [ListItemModel]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                
                ImprovedWormCanvas(segments: viewModel.wormSegments)
                    .border(.black)
            }
            .onAppear {
                // 지렁이 크기와 영역 설정
                viewModel.setBounds(CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height))
//                // 기존 리스트 아이템 설정
//                for item in listItems {
//                    viewModel.addListItem(item)
//                }
                viewModel.resetWorm()
            }
//            .onChange(of: listItems) { newItems in
//                            // 기존 항목을 모두 지우고 새 항목으로 업데이트
//                            let oldItems = viewModel.listItems
//                            
//                            // 제거된 항목 처리
//                            for oldItem in oldItems {
//                                if !newItems.contains(where: { $0.id == oldItem.id }) {
//                                    viewModel.removeListItem(oldItem)
//                                }
//                            }
//                            
//                            // 추가된 항목 처리
//                            for newItem in newItems {
//                                if !oldItems.contains(where: { $0.id == newItem.id }) {
//                                    viewModel.addListItem(newItem)
//                                } else if let oldItem = oldItems.first(where: { $0.id == newItem.id }), oldItem != newItem {
//                                    // 변경된 항목 업데이트
//                                    viewModel.updateListItem(newItem)
//                                }
//                            }
//                        }
        }
        .clipped() // 화면 밖으로 나가는 부분 클리핑
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
                
                context.stroke(segmentPath, with: .color(.mint01), style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
            }
            
            // 머리 부분 그리기
            if let head = segments.first {
                
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

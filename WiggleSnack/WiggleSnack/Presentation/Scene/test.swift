//
//  test.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI

struct SnakeView: View {
    @State private var position: CGPoint = CGPoint(x: 100, y: 100)
    @State private var direction: CGPoint = CGPoint(x: 1, y: 1)
    @State private var snakeLength: CGFloat = 50  // 초기 길이 약 5cm

    let screenSize = UIScreen.main.bounds
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    var body: some View {
        Image("Image")
            .resizable()
            .frame(width: snakeLength, height: snakeLength)
            .position(position)
            .onReceive(timer) { _ in
                withAnimation(.linear(duration: 0.02)) {
                    updatePosition()
                    increaseLength()
                }
            }
    }

    private func updatePosition() {
        var newX = position.x + direction.x * 2
        var newY = position.y + direction.y * 2

        if newX < snakeLength / 2 || newX > screenSize.width - snakeLength / 2 {
            direction.x *= -1
            newX = position.x + direction.x * 2
        }

        if newY < snakeLength / 2 || newY > screenSize.height - snakeLength / 2 {
            direction.y *= -1
            newY = position.y + direction.y * 2
        }

        position = CGPoint(x: newX, y: newY)
    }

    private func increaseLength() {
        if snakeLength < 200 { // 최대 길이 제한
            snakeLength += 0.1 // 점점 길어지게
        }
    }
}

#Preview {
    SnakeView()
}

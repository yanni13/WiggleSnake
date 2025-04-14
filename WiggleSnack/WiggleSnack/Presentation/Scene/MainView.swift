//
//  MainView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

struct MainView: View {
    /// 도전기록 추가 뷰로 이동
    @State private var isNavigateToAddView: Bool = false
    @State private var path = NavigationPath()

    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                // 상단 버튼
                HStack(spacing: 0) {
                    Spacer()
                    
                    Button(action: {
                        isNavigateToAddView = true
                    }, label: {
                        Image("icon_plus")
                            .resizable()
                            .frame(width: 44, height: 44)
                    })
                    
                    
                    Button(action: {
                        
                    }, label: {
                        Image("icon_share")
                            .resizable()
                            .frame(width: 44, height: 44)
                    })
                }
                
                Text("좋아요, \n오늘도 나만의 기록을 쌓아볼까요?")
                    .font(.H1BoldFont())
                    .foregroundColor(.gray05)
                    .lineSpacing(3)
                    .padding(.horizontal, 19)
                    .padding(.top, 34)
                
                Spacer().frame(height: 12)
                
                Text("오늘의 도전을 통해 지렁이를 키워주세요 ☀️")
                    .font(.H5MediumFont())
                    .foregroundColor(.gray05)
                    .padding(.horizontal, 19)
                
                // 지렁이 칸
                Spacer()
                
                
                CustomBottomBtn(action: {
                    
                }, label: "챌린지 리스트")
                .buttonStyle(.plain)
                
                
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .addChallenge:
                    AddChallengeView()
                    
                }
            }
            
            
        }
        
        
    }
}

#Preview {
    MainView()
}

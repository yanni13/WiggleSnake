//
//  MainView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

struct MainView: View {
    /// 도전기록 추가 뷰로 이동
    @State private var path = NavigationPath()
    
//    let navigationRoute: NavigationRoute = .addChallenge
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                
                // 상단 버튼
                HStack(spacing: 0) {
                    Spacer()
                    
                    NavigationLink(value: NavigationRoute.addChallenge) {
                        Image("icon_plus")
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                    
                    
                    Button(action: {
                        
                    }, label: {
                        Image("icon_share")
                            .resizable()
                            .frame(width: 44, height: 44)
                    })
                }
                
                VStack(spacing: 0) {
                    Text("좋아요, \n오늘도 나만의 기록을 쌓아볼까요?")
                        .font(.H1BoldFont())
                        .foregroundColor(.gray05)
                        .lineSpacing(3)
                        .padding(.top, 34)
                    
                    Spacer().frame(height: 12)
                    
                    Text("오늘의 도전을 통해 지렁이를 키워주세요 ☀️")
                        .font(.H5MediumFont())
                        .foregroundColor(.gray05)
                }
                .padding(.horizontal, 20)

                
                // 지렁이 칸
                WormView()
                

                CustomBottomBtn(action: {
                    path.append(NavigationRoute.challengeList)

                }, label: "챌린지 리스트")
                .buttonStyle(.plain)
                .padding(.bottom, 34)
                .padding(.horizontal, 20)

                
            }
            .edgesIgnoringSafeArea(.bottom)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .addChallenge:
                    AddChallengeView()
                case .challengeList:
                    ChallengeListView()
                }
                
                
            }
            
            
        }
        
        
    }
}

#Preview {
    MainView()
}

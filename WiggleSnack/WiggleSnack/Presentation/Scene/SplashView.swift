//
//  SplashView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("반가워요!\n오늘의 작은 도전, 시작해볼까요?")
                    .font(.H2SemiboldFont())
                    .foregroundColor(.gray05)
                    .lineSpacing(3)
                    .border(.black)
                    .padding(.horizontal, 19)
                    .padding(.top, 80)
                
                Spacer().frame(height: 12)
                
                Text("지렁이의 하루는 당신의 도전으로 시작돼요 ☀️")
                    .font(.H5MediumFont())
                    .foregroundColor(.gray05)
                    .border(.black)
                    .padding(.horizontal, 19)

                // 지렁이 칸
                Spacer()
                

                CustomBottomBtn(action: {
                    
                }, label: "챌린지 리스트")
                .buttonStyle(.plain)


            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    SplashView()
}

//
//  ChallengeDetailView.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/18/25.
//

import SwiftUI

struct ChallengeDetailView: View {
    var body: some View {
        VStack {
            
        }
        .navigationTitle("나의 도전 일기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackBtn()
                        .padding(.leading, 5)
                        .contentShape(Rectangle())
                }
                .offset(x: -10)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                menuComponent()
            }
        }
    }
    
    @ViewBuilder
    private func menuComponent() -> some View {
        Menu {
            Button(action: {
                
            }, label: {
                Text("수정")
            })
            
            Button(action: {
                
            }, label: {
                Text("삭제")
            })
        } label: {
            HStack {
                Button(action: {
                    
                }, label: {
                    Image("icon_navigationbar_kebabmenu")
                        .resizable()
                        .frame(width: 44, height: 44)
                })
            }
            .offset(x: 10)
        }
    }
}

#Preview {
    ChallengeDetailView()
}

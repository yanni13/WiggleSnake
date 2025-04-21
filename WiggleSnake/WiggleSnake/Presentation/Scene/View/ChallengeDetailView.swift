//
//  ChallengeDetailView.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/18/25.
//

import SwiftUI

struct ChallengeDetailView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var deleteViewModel: DeleteChallengeViewModel

    var item: ListItemModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 35)

            CalendarComponent(month: Date(), item: item)
            
            Spacer().frame(height: 60)

            VStack(alignment: .leading, spacing: 10) {
                Text("다짐 및 도전 목표")
                    .foregroundColor(.gray05)
                    .font(.H4MediumFont())
                
                
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                      .foregroundColor(.gray01)
                      .cornerRadius(4)
                    Text(item.memo)
                        .foregroundColor(.gray05)
                        .padding(13)
                        .font(.H5MediumFont())
    
    
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .navigationTitle(item.title)
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
                deleteViewModel.deleteChallenge(for: item, context: context) { success in
                    if success {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    } else {
                        print("[ChallengeDetailView]: 삭제 실패")
                    }
                    
                }
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


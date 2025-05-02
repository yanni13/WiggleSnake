//
//  ChallengeDetailView.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/18/25.
//

import SwiftUI

struct ChallengeDetailView: View {
    @State private var challenges: [ListItemModel] = []
    @Binding var path: NavigationPath
    var item: ListItemModel

    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: ChallengeViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer().frame(height: 35)
                
                CalendarComponent(month: Date(), completedDates: $viewModel.completedDates, item: item)
                
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("다짐 및 도전 목표")
                        .foregroundColor(.gray05)
                        .font(.H4MediumFont())
                    
                    
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
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
        .onChange(of: viewModel.updateTrigger) { newValue in
            viewModel.fetchAllChallenges(context: context)
            challenges = viewModel.items
            
            viewModel.updateTrigger = false
            Log.debug("[ChallengeDetailView]: \(challenges)")
        }
    }
    
    @ViewBuilder
    private func menuComponent() -> some View {
        Menu {
            Button(action: {
                path.append(NavigationRoute.editChallenge(item))
            }, label: {
                Text("수정")
            })
            
            Button(action: {
                viewModel.deleteChallenge(for: item, context: context) { success in
                    if success {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    } else {
                        Log.debug("[ChallengeDetailView]: 삭제 실패")
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


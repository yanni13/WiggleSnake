//
//  SplashView.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/23/25.
//

import SwiftUI

struct SplashView: View {
    @State private var path = NavigationPath()
    @StateObject var viewModel = ChallengeViewModel()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                VStack(alignment: .leading) {
                    Text("반가워요!\n오늘의 작은 도전, 시작해볼까요?")
                        .font(.H1BoldFont())
                        .foregroundColor(.gray05)
                        .lineSpacing(3)
                        .padding(.top, 94)
                    
                    Spacer().frame(height: 12)
                    
                    Text("지렁이의 하루는 당신의 도전으로 시작돼요 ☀️")
                        .font(.H4MediumFont())
                        .foregroundColor(.gray05)
                        
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)


                Spacer().frame(height: 100)
                
                    Image("WiggleSnake")
                        .resizable()
                        .frame(maxWidth: 180, maxHeight: 180)

                Spacer()
                
                

                CustomBottomBtn(action: {
                    path.append(NavigationRoute.mainView)
                }, label: "시작하기")
                .buttonStyle(.plain)
                .padding(.horizontal, 20)


            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .mainView:
                    MainView(path: $path, viewModel: viewModel)
                case .addChallenge:
                    AddChallengeView(path: $path, viewModel: viewModel, mode: .add, editingItem: nil)
                case .editChallenge(let item):
                    AddChallengeView(path: $path, viewModel: viewModel, mode: .edit, editingItem: item)
                case .challengeList:
                    ChallengeListView(viewModel: viewModel, path: $path)
                case .challengeDetail(let item):
                    ChallengeDetailView(path: $path, item: item, viewModel: viewModel)
                }
                
            }
            
        }
        
    }
}

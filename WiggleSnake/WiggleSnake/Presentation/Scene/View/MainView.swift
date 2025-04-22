//
//  MainView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import CoreData
import SwiftUI

struct MainView: View {
    /// 도전기록 추가 뷰로 이동
    @Environment(\.managedObjectContext) private var context
    @State private var path = NavigationPath()
    @StateObject var viewModel = ChallengeViewModel()
    @State private var item: ListItemModel?

    
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
                
                VStack(alignment: .leading) {
                    Text("좋아요, \n오늘도 나만의 기록을 쌓아볼까요?")
                        .font(.H1BoldFont())
                        .foregroundColor(.gray05)
                        .lineSpacing(3)
                        .padding(.top, 34)
                                            
                    Spacer().frame(height: 12)
                    
                    Text("오늘의 도전을 통해 지렁이를 키워주세요 ☀️")
                        .font(.H4MediumFont())
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
                    AddChallengeView(path: $path, viewModel: viewModel, mode: .add, editingItem: nil)
                case .editChallenge(let item):
                    AddChallengeView(path: $path, viewModel: viewModel, mode: .edit, editingItem: item)
                case .challengeList:
                    ChallengeListView(viewModel: viewModel, path: $path)
                case .challengeDetail(let item):
                    ChallengeDetailView(path: $path, item: item, viewModel: viewModel)
                }
                
            }
            .onAppear {
                fetchAndPrintChallenges()
                item = nil
            }
        }
    }
    
    // MARK: 데이터 잘 불러오고 있는지 로그찍는 함수
    private func fetchAndPrintChallenges() {
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        
        do {
            let challenges = try context.fetch(fetchRequest)
            print("🔍 불러온 Challenge 수: \(challenges.count)")
            
            for (index, challenge) in challenges.enumerated() {
                print("------ Challenge \(index + 1) ------")
                print("📝 제목: \(challenge.title ?? "없음")")
                print("📄 메모: \(challenge.memo ?? "없음")")
                print("📂 카테고리: \(challenge.category ?? "없음")")
                print("📅 시작일: \(challenge.startDate?.description ?? "없음")")
                print("📅 종료일: \(challenge.endDate?.description ?? "없음")")
            }
            
        } catch {
            print("❌ Challenge 불러오기 실패: \(error)")
        }
    }
    
}

#Preview {
    MainView()
}

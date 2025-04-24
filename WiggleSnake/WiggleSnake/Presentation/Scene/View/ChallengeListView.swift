//
//  ChallengeListView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI
import ConfettiSwiftUI

struct ChallengeListView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var viewModel: ChallengeViewModel
    
    @State private var selectedTab: String = "진행중"
    /// 저장된 데이터를 불러와서 items 배열에 저장하기 위한 변수
    @State private var items: [ListItemModel] = []
    /// 토스트바 표시하기 위한 변수
    @State private var showToast: Bool = false
    /// 컨페티 표시하기 위한 변수
    @State private var triggerConfetti: Bool = false
    
    @Binding var path: NavigationPath
    
    let textLabel = ["진행중", "완료"]
    
    private var filteredItems: [ListItemModel] {
        let now = Date()
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let koreanNow = now.addingTimeInterval(TimeInterval(koreanTimeZone.secondsFromGMT(for: now)))

        let calendar = Calendar(identifier: .gregorian)
        let activeItems = viewModel.items.filter { item in
            let endDateInclusive = calendar.date(byAdding: .day, value: 1, to: item.endDate)!
            return koreanNow >= item.startDate && koreanNow < endDateInclusive
        }

        return selectedTab == "진행중"
        ? activeItems.filter { !$0.isCompleted }
        : activeItems.filter { $0.isCompleted }
    }
    
    
    var groupedItems: [CategoryIcon: [ListItemModel]] {
        Dictionary(grouping: filteredItems, by: { $0.category })
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 23)
                    
                    Picker("", selection: $selectedTab) {
                        ForEach(textLabel, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding(.horizontal, 20)
                    .pickerStyle(.segmented)
                    .background(.white)
                    
                    Spacer().frame(height: 18)
                    
                    if items.isEmpty {
                        VStack {
                            Spacer().frame(height: 250)
                            
                            Text("지렁이의 하루는 당신의 도전으로 시작돼요 ☀️")
                                .font(.H4MediumFont())
                                .foregroundColor(.gray04)
                                .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    } else {
                        ForEach(Array(groupedItems.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { category in
                            let categoryItems = groupedItems[category] ?? []
                            
                            VStack(alignment: .leading) {
                                Text(category.groupTitle)
                                    .font(.H3SemiboldFont())
                                    .foregroundColor(.gray05)
                                    .padding(.leading, 29)
                                    .padding(.top, 20)
                                
                                
                                Spacer().frame(height: 25)
                                
                                VStack(spacing: 20) {
                                    ForEach(categoryItems.indices, id: \.self) { index in
                                        let item = categoryItems[index]
                                        
                                        // fetchViewModel.items 기반으로 Binding 생성
                                        let itemBinding = Binding<ListItemModel>(
                                            get: {
                                                viewModel.items.first(where: { $0.id == item.id }) ?? item
                                            },
                                            set: { newValue in
                                                if let i = viewModel.items.firstIndex(where: { $0.id == newValue.id }) {
                                                    viewModel.items[i] = newValue
                                                }
                                            }
                                        )
                                        
                                        ListComponent(
                                            item: itemBinding,
                                            path: $path,
                                            onCheck: {
                                                if selectedTab == "진행중" {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        showToast = true
                                                        triggerConfetti = true
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                        withAnimation(.easeInOut(duration: 0.3)) {
                                                            showToast = false
                                                            triggerConfetti = false
                                                        }
                                                    }
                                                }
                                            },
                                            viewModel: viewModel
                                        )
                                        .padding(.horizontal, 20)
                                    }
                                    
                                    // 카테고리 항목이 2개이상이여야 표시됨
                                    if category != groupedItems.keys.sorted(by: { $0.rawValue < $1.rawValue }).last {
                                        Rectangle()
                                            .frame(height: 8)
                                            .foregroundColor(.gray01)
                                    }
                                }
                                
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.bottom, 40)
            
            
            VStack {
                Color.clear
                    .edgesIgnoringSafeArea(.all)
                    .confettiCannon(trigger: $triggerConfetti, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 300), radius: 400, repetitions: 1)
                
                Spacer()
            }
            .allowsHitTesting(false)
            
            if showToast {
                VStack {
                    Spacer()
                    CustomToastComponent(text: "지렁이의 꼬리가 10cm 자랐어요!", icon: "🎉", color: .pink02, textColor: .white)
                        .padding(.bottom, 34)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                }
            }
        }
        .navigationTitle(Text("나의 도전 일지"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackBtn()
                        .padding(.leading, 5)
                        .contentShape(Rectangle())
                    
                }.offset(x: -10)
            }
        }
        .onAppear {
            let testDate = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 27))!
            viewModel.currentDate = testDate
            
            items = viewModel.fetchAllChallenges(context: context)
    
        }
        
    }
}

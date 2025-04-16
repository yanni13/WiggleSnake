//
//  ChallengeListView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI

struct ChallengeListView: View {
    @State private var selectedTab: String = "진행중"    // 더미데이터
    @State private var items: [ListItemModel] = [
        ListItemModel(category: .운동, title: "운동하기", dateRange: "7/1 ~ 7/7", isCompleted: false),
        ListItemModel(category: .자기계발, title: "공부하기", dateRange: "7/1 ~ 7/7", isCompleted: false),
        ListItemModel(category: .운동, title: "운동하기", dateRange: "7/1 ~ 7/7", isCompleted: false)
    ]
    let textLabel = ["진행중", "완료"]
    
    var groupedItems: [CategoryIcon: [ListItemModel]] {
        var result = [CategoryIcon: [ListItemModel]]()
        
        let filteredItems = selectedTab == "진행중"
        ? items.filter { !$0.isCompleted }
        : items.filter { $0.isCompleted }
        
        for item in filteredItems {
            if result[item.category] == nil {
                result[item.category] = [item]
            } else {
                result[item.category]?.append(item)
            }
        }
        
        return result
    }
    
    var body: some View {
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
                
                
                ForEach(Array(groupedItems.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { category in
                    let categoryItems = groupedItems[category] ?? []

                    VStack(alignment: .leading) {
                        Text(category.groupTitle)
                            .font(.H3SemiboldFont())
                            .foregroundColor(.gray05)
                            .padding(.leading, 29)
                            .padding(.top, 20)
                        
                        
                        Spacer().frame(height: 17)
                        
                        VStack(spacing: 20) {
                            ForEach(categoryItems.indices, id: \.self) { index in
                                let itemBinding = Binding<ListItemModel>(
                                    get: {
                                        // 원본 items 배열에서 해당 항목 찾기
                                        if let originalIndex = items.firstIndex(where: { $0.id == categoryItems[index].id }) {
                                            return items[originalIndex]
                                        }
                                        return categoryItems[index]
                                    },
                                    set: { newValue in
                                        // 원본 items 배열에서 해당 항목 업데이트
                                        if let originalIndex = items.firstIndex(where: { $0.id == categoryItems[index].id }) {
                                            items[originalIndex] = newValue
                                        }
                                    }
                                )
                                
                                ListComponent(item: itemBinding)
                                    .padding(.horizontal, 20)
                                                            }

                            // 카테고리 항목이 2개이상이여야 표시됨
                            if category != groupedItems.keys.sorted(by: { $0.rawValue < $1.rawValue }).last {
                                Rectangle()
                                    .frame(height: 8)
                                    .foregroundColor(.gray01)
                                    .padding(.top, 10)
                            }
                        }
                    }
                }
                
                
                Spacer()
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
    }
}

#Preview {
    ChallengeListView()
}

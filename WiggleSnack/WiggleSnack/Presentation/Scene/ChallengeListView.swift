//
//  ChallengeListView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI

struct ChallengeListView: View {
    @State private var selectedTab: Int? = 1
    // 더미데이터
    @State private var items: [ListItemModel] = [
        ListItemModel(category: .운동, title: "운동하기", dateRange: "7/1 ~ 7/7", isCompleted: false),
        ListItemModel(category: .운동, title: "운동하기", dateRange: "7/1 ~ 7/7", isCompleted: false),
        ListItemModel(category: .운동, title: "운동하기", dateRange: "7/1 ~ 7/7", isCompleted: false)
    ]
    let textLabel = ["진행중", "완료"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer().frame(height: 23)
                
                Picker("", selection: $selectedTab) {
                    ForEach(textLabel, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .background(.white)
                
                Spacer().frame(height: 38)
                
                Text("자기계발")
                    .font(.H3SemiboldFont())
                    .foregroundColor(.gray05)
                    .padding(.leading, 9)
                
                Spacer().frame(height: 13)
                
                ForEach($items) { $item in
                    ListComponent(item: $item)
                }
                
                Spacer()
            }
        }
        .navigationTitle(Text("나의 도전 일지"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .padding(.horizontal, 20)
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

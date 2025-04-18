//
//  ChallengeListView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI


struct ChallengeListView: View {
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var fetchViewModel: FetchChallengeViewModel
    @State private var selectedTab: String = "진행중"
    /// 저장된 데이터를 불러와서 items 배열에 저장하기 위한 변수
    @State private var items: [ListItemModel] = []
    /// 도전기록 상세보기 뷰로 넘어가기 위한 상태변수
    @State private var isPresented: Bool = false
    /// 선택된 리스트 아이템을 저장하는 변수
    @State private var selectedItem: ListItemModel?
    @Binding var path: NavigationPath
    
    let textLabel = ["진행중", "완료"]
    
    private var filteredItems: [ListItemModel] {
        selectedTab == "진행중"
        ? items.filter { !$0.isCompleted }
        : items.filter { $0.isCompleted }
    }
    
    var groupedItems: [CategoryIcon: [ListItemModel]] {
        Dictionary(grouping: filteredItems, by: { $0.category })
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
                        
                        
                        Spacer().frame(height: 25)
                        
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
                                ListComponent(item: itemBinding, path: $path, fetchViewModel: fetchViewModel)
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
                
                
                Spacer()
            }
            
//            NavigationLink(destination: ChallengeDetailView(item: ), isActive: $isPresented) {}
//                .hidden()
//                .buttonStyle(PlainButtonStyle())
            
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
            items = fetchViewModel.fetchAllChallenges(context: context)
        }
    }
}

//#Preview {
//    ChallengeListView(fetchViewModel: FetchChallengeViewModel())
//}

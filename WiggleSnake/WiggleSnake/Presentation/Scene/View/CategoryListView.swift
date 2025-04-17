//
//  CategoryListView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI

struct CategoryListView: View {
    
    /// 카테고리의 상태를 담는 변수
    @ObservedObject var viewModel: AddChallengeViewModel
    @Binding var selectedIndex: Int
    
    let columns = [GridItem(.flexible(), spacing: 30), GridItem(.flexible(), spacing: 30)]
    let categories = CategoryIcon.allCases

    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                
                Text("카테고리를 선택해주세요")
                    .font(.H3SemiboldFont())
                    .foregroundStyle(.gray05)
                    .padding(.leading, 1)
                
                categoryComponent()
                
            }
            .padding(.horizontal, 28)
            
        }
        .frame(maxWidth: .infinity)
        
    }
    
    @ViewBuilder
    private func categoryComponent() -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<categories.count, id: \.self) { index in
                let category = categories[index]
                let isSelected = selectedIndex == index
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                        viewModel.category = categories[index].groupTitle
                    }
                }, label: {
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .foregroundColor(selectedIndex == index ? .pink02 : .gray01)
                            .frame(width: 152, height: 160)
                            .cornerRadius(8)
                        
                        Text(category.groupTitle)
                            .font(.H3MediumFont())
                            .foregroundColor(selectedIndex == index ? .white : .gray05)
                            .padding(.leading, 16)
                            .padding(.top, 23)
                        
                        Text(category.emoji)
                            .font(.system(size: 80))
                            .position(x: 100, y: 110)
                    }
                    
                })
                .buttonStyle(.plain)
                
                
            }
            
        }
        .padding()
    }
}

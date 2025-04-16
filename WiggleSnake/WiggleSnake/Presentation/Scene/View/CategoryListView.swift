//
//  CategoryListView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI

struct CategoryListView: View {
    
    /// 카테고리의 상태를 담는 변수
    @Binding var selectedIndex: Int
    
    let columns = [GridItem(.flexible(), spacing: 30), GridItem(.flexible(), spacing: 30)]
    let text = ["운동", "자기계발", "마음챙김", "생활루틴", "소비습관", "소통", "디지털디톡스", "취미생활"]
    let icon = ["🏃", "📚", "🧘" , "🧽", "💰", "👭🏼", "📵", "🎨"]
    
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
            ForEach(0..<text.count, id: \.self) { index in
                let isSelected = selectedIndex == index
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                }, label: {
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .foregroundColor(selectedIndex == index ? .pink02 : .gray01)
                            .frame(width: 152, height: 160)
                            .cornerRadius(8)
                        
                        Text(text[index])
                            .font(.H3MediumFont())
                            .foregroundColor(selectedIndex == index ? .white : .gray05)
                            .padding(.leading, 16)
                            .padding(.top, 23)
                        
                        Text(icon[index])
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

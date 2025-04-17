//
//  ListComponent.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//
import Foundation
import SwiftUI

struct ListComponent: View {
//    @State private var isActiveBtn: Bool = false
    // 더미데이터
    @State private var items: [ListItemModel] = [
//            ListItemModel(category: .운동, title: "운동하기", dateRange: "7/1 ~ 7/7", isCompleted: false),
//            ListItemModel(category: .운동, title: "운동하기", dateRange: "7/1 ~ 7/7", isCompleted: false),
//            ListItemModel(category: .운동, title: "운동하기", dateRange: "7/1 ~ 7/7", isCompleted: false)
        ]
    @Binding var item: ListItemModel

    let category: CategoryIcon = .운동
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing: 15) {
                IconImage(for: item.category)
                    .padding(.leading, 8)
                
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.B1SemiboldFont())
                        .foregroundColor(.gray05)
                        .lineSpacing(1)
                    
//                    Text(item.dateRange)
//                        .font(.B1MediumFont())
//                        .foregroundColor(.gray05)
                }
                
                Spacer()
                
                Button(action: {
                    item.isCompleted.toggle()
                }, label: {
                    Image(item.isCompleted ? "icon_check_pink" : "icon_check")
                        .frame(width: 44, height: 44)
                })
                

            }
        }
    }
    
    @ViewBuilder
    private func IconImage(for category: CategoryIcon) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 47, height: 47)
                .foregroundColor(.gray01)
                .cornerRadius(8)
            
            Text(category.emoji)
                .font(.system(size: 28))
                .zIndex(1)
        }
    }
}

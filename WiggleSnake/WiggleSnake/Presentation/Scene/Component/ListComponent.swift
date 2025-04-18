//
//  ListComponent.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//
import Foundation
import SwiftUI
import Combine

struct ListComponent: View {
    @Binding var item: ListItemModel
    @Binding var path: NavigationPath
    @Environment(\.managedObjectContext) private var context

    
    var fetchViewModel: FetchChallengeViewModel

    let category: CategoryIcon = .운동
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing: 15) {
                IconImage(for: item.category)
                    .padding(.leading, 8)
                
                Button(action: {
                    path.append(NavigationRoute.challengeDetail(item))
                }, label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.title)
                            .font(.B1SemiboldFont())
                            .foregroundColor(.gray05)
                            .lineSpacing(1)
                        
                        Text(item.dateRangeText)
                            .font(.B1MediumFont())
                            .foregroundColor(.gray05)
                    }
                })
                
                Spacer()
                
                Button(action: {
                    item.isCompleted.toggle()
                    fetchViewModel.updateCompletion(for: item, context: context)
                    
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

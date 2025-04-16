//
//  CustomToastComponent.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI

struct CustomToastComponent: View {
    let text: String = ""
    let icon: String = ""

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
              .frame(maxWidth: .infinity, maxHeight: 50)
              .foregroundColor(.pink01)
              .cornerRadius(6)
            
            HStack(spacing: 10) {
                
                Text(icon)
                    .font(.system(size: 24))
                    .padding(.leading, 18)
                
                
                Text(text)
                    .font(.B1SemiboldFont())
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CustomToastComponent()
}

//
//  CustomBottomBtn.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

struct CustomBottomBtn: View {
    let action: () -> Void
    let label: String
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                Rectangle()
                    .frame(maxHeight: 55)
                    .foregroundColor(.pink02)
                    .cornerRadius(4)
                
                Text(label)
                    .font(.H4MediumFont())
                    .foregroundColor(.white)
            }
        })
    }
}

#Preview {
    SplashView()
}

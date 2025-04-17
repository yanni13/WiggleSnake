//
//  CustomCalendarView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI

struct CustomCalendarView: View {
    @State private var isActiveDropDownBtn: Bool = false
    
    var body: some View {
        VStack {
            
        }
        .navigationTitle(Text("Swift 공부하기"))
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        isActiveDropDownBtn = true
                    }, label: {
                        Image("icon_navigationbar_kebabmenu")
                            .frame(width: 44, height: 44)
                    })
                    
                }.offset(x: -10)
            }
        }
    }
}

#Preview {
    CustomCalendarView()
}

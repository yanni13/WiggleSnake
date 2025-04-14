//
//  NavigationBackBtn.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

struct NavigationBackBtn: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var action: (() -> Void)?
    
    
    var body: some View {
        Button(action: {
            action?()
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image("icon_navigationbar")
                .resizable()
                .frame(width: 44, height: 44)
        })
        .buttonStyle(.plain)
    }
}

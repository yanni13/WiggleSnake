//
//  InquiryText.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

struct InquiryText: View {
    let title: String
    let isRequired: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.H5MediumFont())
                .foregroundColor(.gray05)
            
            if isRequired {
                Text("*")
                    .font(.H5MediumFont())
                    .foregroundColor(.pink02)
            }
        }
    }
}


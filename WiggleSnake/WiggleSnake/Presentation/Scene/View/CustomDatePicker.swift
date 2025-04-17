//
//  CustomDatePicker.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

import SwiftUI

struct CustomDatePicker: View {
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text("선택된 기간: \(formattedDateRange())")
                .font(.headline)

            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .onChange(of: selectedDate) { newDate in
                    handleDateSelection(newDate)
                }

            Button("초기화") {
                startDate = nil
                endDate = nil
            }
        }
        .padding()
    }

    private func handleDateSelection(_ date: Date) {
        if startDate == nil {
            startDate = date
        } else if endDate == nil {
            if date < startDate! {
                endDate = startDate
                startDate = date
            } else {
                endDate = date
            }
        } else {
            // 둘 다 있으면 초기화 후 다시 시작
            startDate = date
            endDate = nil
        }
    }

    private func formattedDateRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        if let start = startDate {
            if let end = endDate {
                return "\(formatter.string(from: start)) ~ \(formatter.string(from: end))"
            } else {
                return "\(formatter.string(from: start)) ~ "
            }
        } else {
            return "시작일 ~ 종료일"
        }
    }
}


#Preview {
    CustomDatePicker()
}

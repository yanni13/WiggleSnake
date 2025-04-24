//
//  CalendarComponent.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/21/25.
//

import SwiftUI

struct CalendarComponent: View {
    @State var month: Date
    @State var offset: CGSize = CGSize()
    @Binding var completedDates: Set<Date>
    var item: ListItemModel
    
    private var normalizedCompletedDates: Set<Date> {
        Set(completedDates.map { $0.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)})
    }
    
    private var dateRange: [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        var currentDate = item.startDate.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
        let endDate = item.endDate.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
        
        while currentDate <= endDate {
            dates.append(currentDate)
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        return dates
    }
    
    var body: some View {
        VStack {
            headerView
            
            Spacer().frame(height: 25)
            
            calendarGridView
            
        }
    }
    
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            HStack {
                Text(month, formatter: Self.dateFormatter)
                    .font(.H2SemiboldFont())
                
                Spacer()
                
                Button(action: {
                    changeMonth(by: -1)
                }, label: {
                    Image("icon_arrow_back_small")
                        .resizable()
                        .frame(width: 36, height: 36)
                })
                
                Button(action: {
                    changeMonth(by: 1)
                }, label: {
                    Image("icon_arrow_front_small")
                        .resizable()
                        .frame(width: 36, height: 36)
                })
                
            }
            .padding(.horizontal, 23)
            
            Spacer().frame(height: 28)
            
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                        .font(.H5MediumFont())
                        .foregroundColor(.gray04)
                }
            }
            .padding(.bottom, 5)
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - 날짜 그리드 뷰
    // CalendarComponent 내부에서 calendarGridView 수정
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                    } else {
                        let date = getDate(for: index - firstWeekday)
                        let normalizedDate = date.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
                        let day = index - firstWeekday + 1
                        let isInDateRange = isDateInRange(date)
                        let isFirstDay = normalizedDate == item.startDate.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
                        let isLastDay = normalizedDate == item.endDate.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
                        let isPreviousDayInRange = isDateInRange(Calendar.current.date(byAdding: .day, value: -1 , to: date) ?? date)
                        let isNextDayInRange = isDateInRange(Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date)
                        let isCompleted = normalizedCompletedDates.contains { $0.isSameDay(as: normalizedDate) }
                        let isToday = today == normalizedDate
                        
                        VStack {
                            CellView(day: day,
                                     isInRange: isInDateRange,
                                     isFirstDay: isFirstDay,
                                     isLastDay: isLastDay,
                                     isPreviousDayInRange: isPreviousDayInRange && !isFirstDay,
                                     isNextDayInRange: isNextDayInRange && !isLastDay,
                                     isCompleted: isToday
                            )
                            .frame(height: 60)
                            .onAppear {
                                if isInDateRange {
                                    print("📅 Checking \(Self.debugDateFormatter.string(from: normalizedDate))")
                                    print("   ↳ isCompleted: \(isCompleted)")
                                }
                                for index in 0..<daysInMonth {
                                    let date = getDate(for: index)
                                    let normalizedDate = date.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
                                    let isCompleted = normalizedCompletedDates.contains(normalizedDate)
                                    print("📅 Date: \(normalizedDate), isCompleted: \(isCompleted)")
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    // 주어진 날짜가 범위 내에 있는지 확인
    private func isDateInRange(_ date: Date) -> Bool {
        let startDate = item.startDate.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
        let endDate = item.endDate.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
        let targetDate = date.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
        
        return targetDate >= startDate && targetDate <= endDate
    }
    
    // 디버깅용 날짜 포맷터
    private static let debugDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    var day: Int
    var isInRange: Bool = false
    var isFirstDay: Bool = false
    var isLastDay: Bool = false
    var isPreviousDayInRange: Bool = false
    var isNextDayInRange: Bool = false
    var isCompleted: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .opacity(0)
                .overlay(Text(String(day)))
                .zIndex(1)
                .foregroundColor(.gray05)
                .padding(.bottom, 30)
            
            if isCompleted {
                Circle()
                    .foregroundStyle(.pink01)
                    .padding(.bottom, 30)
                    .frame(maxWidth: .infinity)
                    .zIndex(0)
            }
            
            // 이전 날짜와 연결(왼쪽)
            if isInRange && isPreviousDayInRange {
                HStack {
                    Rectangle()
                        .foregroundColor(.pink02)
                        .frame(height: 6)
                    Spacer()
                }
                .padding(.leading, -5)
                .padding(.top, 30)
            }
            
            // 다음 날짜와 연결(오른쪽)
            if isInRange && isNextDayInRange {
                HStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(.pink02)
                        .frame(height: 6)
                }
                .padding(.trailing, -5)
                .padding(.top, 30)
                
            }
            
            // 특별한 날짜 표시기
            if isInRange {
                if isFirstDay == isLastDay {
                    HStack {
                        Rectangle()
                            .foregroundColor(.pink02)
                            .frame(height: 6)
                            .cornerRadius(10)
                            .frame(width: 50)
                    }
                    .padding(.top, 30)
                }
                
                if isFirstDay {
                    // 첫 번째 날짜
                    HStack {
                        Rectangle()
                            .foregroundColor(.pink02)
                            .frame(height: 6)
                            .cornerRadius(10)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    
                } else if isLastDay {
                    // 마지막 날짜
                    HStack {
                        Rectangle()
                            .foregroundColor(.pink02)
                            .frame(height: 6)
                            .cornerRadius(10)
                        
                    }
                    .padding(.top, 30)
                }
            }
        }
    }
}



// MARK: - 내부 메서드
private extension CalendarComponent {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> Date {
        let calendar = Calendar.current
        let startOfMonth = self.startOfMonth()
        return calendar.date(byAdding: .day, value: day, to: startOfMonth) ?? Date()
    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
    
    /// 해당 날짜가 챌린지 기간에 포함되는지 여부
    func isInChallengeRange(_ date: Date) -> Bool {
        return date >= item.startDate.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!) && date <= item.endDate.startOfDay(in: TimeZone(identifier: "Asia/Seoul")!)
    }
    
}

// MARK: - CalendarView Static 프로퍼티
private extension CalendarComponent {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월"
        return formatter
    }()
    
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
}

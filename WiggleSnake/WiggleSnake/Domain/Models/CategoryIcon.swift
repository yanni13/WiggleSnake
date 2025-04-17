//
//  CategoryIcon.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/15/25.
//

enum CategoryIcon: String, CaseIterable {
    case 운동, 자기계발, 마음챙김, 생활루틴, 소비습관, 소통, 디지털디톡스, 취미

    var emoji: String {
        switch self {
        case .운동: return "🏃"
        case .자기계발: return "📚"
        case .마음챙김: return "🧘"
        case .생활루틴: return "🧽"
        case .소비습관: return "💰"
        case .소통: return "👭🏼"
        case .디지털디톡스: return "📵"
        case .취미: return "🎨"
        }
    }
    
    var groupTitle: String {
        return self.rawValue
    }
}

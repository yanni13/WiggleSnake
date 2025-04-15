//
//  DynamicFontSize.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

extension Font {
    static func H1BoldFont() -> Font {
        return Font.custom("Pretendard-Bold", size: 20)
    }

    static func H1SemiboldFont() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 24)
    }

    static func H2SemiboldFont() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 20) // 0
    }

    static func H3SemiboldFont() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 18) 
    }
    
    static func H3MediumFont() -> Font {
        return Font.custom("Pretendard-Medium", size: 18)
    }

    static func H4MediumFont() -> Font {
        return Font.custom("Pretendard-Medium", size: 17) // 0
    }
    
    static func H5MediumFont() -> Font {
        return Font.custom("Pretendard-Medium", size: 15) // 0
    }

    static func H6MediumFont() -> Font {
        return Font.custom("Pretendard-Medium", size: 13) // 0
    }

    static func B1MediumFont() -> Font {
        return Font.custom("Pretendard-Medium", size: 12)
    }

    static func B1SemiboldFont() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 14) // 0
    }

    static func B2MediumFont() -> Font {
        return Font.custom("Pretendard-Medium", size: 12) // 0
    }

    static func B2SemiboldFont() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 11)
    }

    static func B2RegularFont() -> Font {
        return Font.custom("Pretendard-Regular", size: 11)
    }
}

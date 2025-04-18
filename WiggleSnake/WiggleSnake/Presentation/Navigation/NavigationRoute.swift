//
//  NavigationRoute.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//
import Combine

// 앱의 적절한 위치에 추가 (예: NavigationRoute.swift 파일)
enum NavigationRoute: Hashable {
    case addChallenge
    case challengeList
    case challengeDetail(ListItemModel)
}

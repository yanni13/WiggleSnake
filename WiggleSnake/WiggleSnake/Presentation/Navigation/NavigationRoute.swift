//
//  NavigationRoute.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//
import Combine

enum NavigationRoute: Hashable {
    case mainView
    case addChallenge
    case editChallenge(ListItemModel)
    case challengeList
    case challengeDetail(ListItemModel)
}

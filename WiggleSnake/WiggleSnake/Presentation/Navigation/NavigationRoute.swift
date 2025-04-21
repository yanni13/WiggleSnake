//
//  NavigationRoute.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//
import Combine

enum NavigationRoute: Hashable {
    case addChallenge
    case challengeList
    case challengeDetail(ListItemModel)
}

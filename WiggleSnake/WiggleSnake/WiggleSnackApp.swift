//
//  WiggleSnackApp.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

@main
struct WiggleSnackApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

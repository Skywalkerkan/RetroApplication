//
//  RetroAppApp.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI

@main
struct RetroAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

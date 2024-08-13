//
//  RetroAppApp.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//


import SwiftUI
import FirebaseCore
import SwiftData

@main
struct RetroAppApp: App {
    init() {
        FirebaseApp.configure()
        DeviceManager.shared.initializeDeviceID()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: [SessionPanel.self])
        }
    }
}

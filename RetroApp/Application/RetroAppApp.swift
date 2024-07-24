//
//  RetroAppApp.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//


import SwiftUI
import FirebaseCore

@main
struct RetroAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

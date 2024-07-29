//
//  MainViewModel.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager()
    
    @Published var isItValidId = false

    
    
    func joinSession(_ sessionId: String) {
        firebaseManager.joinSession(sessionId: sessionId) { isValidId in
            if isValidId {
                self.isItValidId = true
                print("Successfully joined session")
            } else {
                self.isItValidId = false
                print("Session expired or does not exist")
            }
        }
    }
    
}

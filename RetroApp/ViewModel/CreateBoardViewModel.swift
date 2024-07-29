//
//  CreateBoardViewModel.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

class CreateBoardViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager()
    @Published var sessionStatus: String = ""

    func createSession(createdBy: String?, sessionId: String) {
        firebaseManager.createSession(sessionId: sessionId, createdBy: createdBy ?? "Anonymous") { success in
            DispatchQueue.main.async {
                if success {
                    self.sessionStatus = "Session created with ID: \(sessionId)"
                } else {
                    self.sessionStatus = "Failed to create session"
                }
            }
        }
    }
    
    func joinSession(sessionId: String) {
        firebaseManager.joinSession(sessionId: sessionId) { canJoin in
            DispatchQueue.main.async {
                if canJoin {
                    self.sessionStatus = "Successfully joined session"
                } else {
                    self.sessionStatus = "Session expired or does not exist"
                }
            }
        }
    }

}

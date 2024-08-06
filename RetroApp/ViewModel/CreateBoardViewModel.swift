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
    @Published var retroStyles: [String] = ["Went Well - To Improve - Action Items", "Start - Stop - Continue", "Mad - Sad - Glad", "Happy - Meh - Sad"]
    @Published var boardRetroNames: [String: [String]] = [
        "Went Well - To Improve - Action Items": ["Went Well", "To Improve", "Action Items"],
        "Start - Stop - Continue": ["Start", "Stop", "Continue"],
        "Mad - Sad - Glad": ["Mad", "Sad", "Glad"],
        "Happy - Meh - Sad": ["Happy", "Meh", "Sad"]
    ]

    func createSession(createdBy: String?, sessionId: String, timer: Int, sessionName: String, isAnonym: Bool) {
        firebaseManager.createSession(sessionId: sessionId, createdBy: createdBy ?? "Anonymous", timeRemains: timer, sessionName: sessionName, isAnonym: isAnonym) { success in
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
    
    func createBoard(sessionId: String, board: Board) {
        firebaseManager.addBoard(to: sessionId, board: board) { result in
            if result {
                print("ok")
            } else {
                print("no")
            }
        }
    }

}

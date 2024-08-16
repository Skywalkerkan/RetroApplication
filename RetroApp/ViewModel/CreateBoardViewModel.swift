//
//  CreateBoardViewModel.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

class CreateBoardViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager()
    @Published var error: Error?
    @Published var sessionStatus: String = ""
    @Published var retroStyles: [String] = ["Went Well - To Improve - Action Items", "Start - Stop - Continue", "Mad - Sad - Glad", "Happy - Meh - Sad"]
    @Published var boardRetroNames: [String: [String]] = [
        "Went Well - To Improve - Action Items": ["Went Well", "To Improve", "Action Items"],
        "Start - Stop - Continue": ["Start", "Stop", "Continue"],
        "Mad - Sad - Glad": ["Mad", "Sad", "Glad"],
        "Happy - Meh - Sad": ["Happy", "Meh", "Sad"]
    ]

    func createSession(createdBy: String?, sessionId: String, sessionPassword: String, timer: Int, isTimerActive: Bool, sessionName: String, isAnonym: Bool, sessionBackground: String) {
        firebaseManager.createSession(sessionId: sessionId, createdBy: createdBy ?? "Anonymous", timeRemains: timer, isTimerActive: isTimerActive, sessionName: sessionName, isAnonym: isAnonym, sessionPassword: sessionPassword, sessionBackground: sessionBackground) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    print("Successfully Created Session")
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func joinSession(sessionId: String, sessionPassword: String) {
        firebaseManager.joinSession(sessionId: sessionId, sessionPassword: sessionPassword) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isValid):
                    if isValid {
                        print("Successfully joined session")
                    } else {
                        print("Session cannot be found")
                    }
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func createBoard(sessionId: String, board: Board) {
        firebaseManager.addBoard(to: sessionId, board: board) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Successfully Created Board")
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func saveUserSession(user: User) {
        firebaseManager.saveUserSession(user: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Successfully Saved User Session")
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}

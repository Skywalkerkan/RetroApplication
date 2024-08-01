//
//  BoardViewModel.swift
//  RetroApp
//
//  Created by Erkan on 26.07.2024.
//

import Foundation
import FirebaseFirestore
import Combine

class BoardViewModel: ObservableObject {
    @Published var showSessionExpiredAlert = false
    @Published var boards: [Board] = []
    private var sessionExpirationTimer: Timer?
    private var timePrintTimer: Timer?

    private let firebaseManager = FirebaseManager()

    func startSessionExpirationTimer(for sessionId: String) {
        firebaseManager.getSessionExpiration(sessionId: sessionId) { result in
            switch result {
            case .success(let expirationDate):
                let timeInterval = expirationDate.timeIntervalSinceNow
                
                self.sessionExpirationTimer?.invalidate()
                self.timePrintTimer?.invalidate()
                
                if timeInterval > 0 {
                    self.sessionExpirationTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
                        DispatchQueue.main.async {
                            self.showSessionExpiredAlert = true
                        }
                        self.showSessionExpiredAlert = true
                    }
                    
                    self.timePrintTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        let remainingTime = expirationDate.timeIntervalSinceNow
                        if remainingTime > 0 {
                           // print("Remaining time: \(Int(remainingTime)) seconds")
                        } else {
                            DispatchQueue.main.async {
                                self.showSessionExpiredAlert = true
                            }
                            self.timePrintTimer?.invalidate()
                        }
                    }
                } else {
                    self.showSessionExpiredAlert = true
                }
            case .failure(let error):
                print("Failed to get session expiration: \(error)")
            }
        }
    }
    
    func fetchBoards(sessionId: String) {
        firebaseManager.fetchBoards(for: sessionId) { result in
            switch result {
            case.success(let boards):
                self.boards = boards
                print(self.boards)
            case .failure(let error):
                print("error")
            }
        }
    }
    
    func updateBoards(sessionId: String ,boards: [Board]) {
        firebaseManager.updateBoardInFirestore(sessionId: sessionId, updatedBoards: boards) { result in
            if result {
                print("ok")
            } else {
                print("no ok")
            }
        }
    }
    
    func addCardToBoard(sessionId: String, boardIndex: Int, newCard: Card) {
        firebaseManager.addCardToSession(sessionId: sessionId, boardIndex: boardIndex, newCard: newCard) { result in
            if result {
                print("Yazıldı")
            } else {
                print("Yazılamadı")
            }
        }
    }
    
    func deleteBoard(sessionId: String, boardIndex: Int) {
        firebaseManager.deleteBoard(sessionId: sessionId, boardIndex: boardIndex) { result in
            switch result {
            case .success(_):
                print("Success")
            case .failure(let error):
                print("deleting error \(error.localizedDescription)")
            }
        }
    }
}

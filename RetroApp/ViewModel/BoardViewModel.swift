//
//  BoardViewModel.swift
//  RetroApp
//
//  Created by Erkan on 26.07.2024.
//

import SwiftUI

final class BoardViewModel: ObservableObject {
    @Published var showSessionExpiredAlert = false
    @Published var error: Error?
    @Published var boards: [Board] = []
    @Published var session: Session?

    private let firebaseManager = FirebaseManager()
    
    func fetchBoards(sessionId: String) {
        firebaseManager.fetchBoards(for: sessionId) { result in
            switch result {
            case .success(let session):
                self.session = session
                self.boards = session.boards
            case .failure(let error):
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to fetch boards: \(error.localizedDescription)"]
                )
            }
        }
    }
    
    func updateBoards(sessionId: String, boards: [Board]) {
        firebaseManager.updateBoardInFirestore(sessionId: sessionId, updatedBoards: boards) { result in
            switch result {
            case .success(_):
                print("Successfully updated Boards")
            case .failure(let error):
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to update boards: \(error.localizedDescription)"]
                )
            }
        }
    }
    
    func addCardToBoard(sessionId: String, boardIndex: Int, newCard: Card) {
        firebaseManager.addCardToSession(sessionId: sessionId, boardIndex: boardIndex, newCard: newCard) { result in
            switch result {
            case .success(_):
                print("Successfully added card")
            case .failure(let error):
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to add card: \(error.localizedDescription)"]
                )
            }
        }
    }
    
    func createBoard(sessionId: String, board: Board) {
        firebaseManager.addBoard(to: sessionId, board: board) { result in
            switch result {
            case .success(_):
                print("Successfully created board")
            case .failure(let error):
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to create board: \(error.localizedDescription)"]
                )
            }
        }
    }

    func deleteBoard(sessionId: String, boardIndex: Int) {
        firebaseManager.deleteBoard(sessionId: sessionId, boardIndex: boardIndex) { result in
            switch result {
            case .success(_):
                print("Successfully deleted board")
            case .failure(let error):
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to delete board: \(error.localizedDescription)"]
                )
            }
        }
    }
    
    func deleteCardFromBoard(sessionId: String, boardIndex: Int, cardId: String) {
        firebaseManager.deleteCardFromSession(sessionId: sessionId, boardIndex: boardIndex, cardId: cardId) { result in
            if result {
                print("Successfully deleted card")
            } else {
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to delete card"]
                )
            }
        }
    }
    
    func reorderCardInSession(sessionId: String, boardIndex: Int, cards: [Card]) {
        firebaseManager.reorderCardsInSession(sessionId: sessionId, boardIndex: boardIndex, newCardOrder: cards) { result in
            if result {
                print("Successfully reordered cards")
            } else {
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to reorder cards"]
                )
            }
        }
    }
    
    func updateCardName(sessionId: String, boardIndex: Int, cardId: String, newCardDescription: String) {
        firebaseManager.updateCardNameInBoard(sessionId: sessionId, boardIndex: boardIndex, cardId: cardId, newCardDescription: newCardDescription) { result in
            if result {
                print("Successfully updated card name")
            } else {
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to update card name"]
                )
            }
        }
    }
    
    func saveUserSession(user: User) {
        firebaseManager.saveUserSession(user: user) { result in
            switch result {
            case .success(_):
                print("Successfully saved user session")
            case .failure(let error):
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to save user session: \(error.localizedDescription)"]
                )
            }
        }
    }
    
    func getSessionSettings(sessionId: String, completion: @escaping (Bool) -> Void) {
        firebaseManager.getSessionSettings(byId: sessionId) { session, error in
            if let session = session {
                self.session = session
                completion(true)
            } else {
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to get session settings: \(error?.localizedDescription ?? "Unknown error")"]
                )
                completion(false)
            }
        }
    }
    
    func addSettingsToSession(sessionId: String, isAnonymous: Bool, isTimerActive: Bool, timer: Int, timeRemains: Int?, allowUserChange: Bool) {
        firebaseManager.addSettingToSession(byId: sessionId, isAnonymous: isAnonymous, isTimerActive: isTimerActive, timerMinutes: timer, timeRemains: timeRemains, allowUserChange: allowUserChange) { result in
            if result {
                print("Successfully updated session settings")
            } else {
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to update session settings"]
                )
            }
        }
    }
    
    func deleteUserSession(for sessionId: String) {
        firebaseManager.deleteForUserSession(for: sessionId) { result in
            switch result {
            case .success(_):
                print("Successfully deleted user session")
            case .failure(let error):
                self.error = NSError(
                    domain: "BoardViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to delete user session: \(error.localizedDescription)"]
                )
            }
        }
    }
}

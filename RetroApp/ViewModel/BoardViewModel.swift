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
    @Published var session: Session?
    private var sessionExpirationTimer: Timer?
    private var timePrintTimer: Timer?

    private let firebaseManager = FirebaseManager()
    
    func fetchBoards(sessionId: String) {
        firebaseManager.fetchBoards(for: sessionId) { result in
            switch result {
            case.success(let session):
               // self.boards = boards
                    self.session = session
                self.boards = session.boards
                print("session kartları \(session.sessionName)")
            case .failure(let error):
                print("error")
            }
        }
    }
    
    func updateBoards(sessionId: String ,boards: [Board]) {
        firebaseManager.updateBoardInFirestore(sessionId: sessionId, updatedBoards: boards) { result in
            switch result {
            case .success(_):
                print("Succesfully updated Boards")
            case .failure(let error):
                print(error)
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
    
    func createBoard(sessionId: String, board: Board) {
        firebaseManager.addBoard(to: sessionId, board: board) { result in
            switch result {
            case .success(_):
                print("Successfully Created Board.")
                
            case .failure(let error):
                print(error)
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
    
    func deleteCardFromBoard(sessionId: String, boardIndex: Int, cardId: String) {
        firebaseManager.deleteCardFromSession(sessionId: sessionId, boardIndex: boardIndex, cardId: cardId) { result in
            if result {
                print("Başarılı şekilde silindi")
            } else {
                print("Silinemedi")
            }
        }
    }
    
    func reorderCardInSession(sessionId: String, boardIndex: Int, cards: [Card]) {
        firebaseManager.reorderCardsInSession(sessionId: sessionId, boardIndex: boardIndex, newCardOrder: cards) { result in
            if result {
                print("Başarılı bir şekilde değiştirildi kartlar")
            } else {
                print("Kart Yerleri başarısız")
            }
        }
    }
    
    func updateCardName(sessionId: String, boardIndex: Int, cardId: String, newCardDescription: String) {
        firebaseManager.updateCardNameInBoard(sessionId: sessionId, boardIndex: boardIndex, cardId: cardId, newCardDescription: newCardDescription) { result in
            if result {
                print("Başarılı içerik değiştirme")
            } else {
                print("Başarısız içeril değiştirme")
            }
        }
    }
    
    func saveUserSession(user: User) {
        firebaseManager.saveUserSession(user: user) { result in
            switch result {
            case .success(_):
                print("başarılı")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSessionSettings(sessionId: String, completion: @escaping (Bool) -> Void) {
        firebaseManager.getSessionSettings(byId: sessionId) { session, error in
            if let session = session {
                self.session = session
                completion(true)
            } else {
                print("error get session")
                completion(false)
            }
        }
    }
    
    func addSettingsToSession(sessionId: String, isAnonymous: Bool, isTimerActive: Bool, timer: Int, timeRemains: Int?, allowUserChange: Bool) {
        firebaseManager.addSettingToSession(byId: sessionId, isAnonymous: isAnonymous, isTimerActive: isTimerActive, timerMinutes: timer, timeRemains: timeRemains, allowUserChange: allowUserChange) { result in
            if result {
                print("Başarılı bir şekilde güncellendi settings")
            } else {
                print("Hata geldi")
            }
        }
    }
    
}

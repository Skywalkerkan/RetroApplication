//
//  FirebaseManager.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import Firebase
import FirebaseFirestoreSwift

class FirebaseManager {
    private var db = Firestore.firestore()
    
    func createSession(sessionId: String, createdBy: String, timeRemains: Int?, isTimerActive: Bool, sessionName: String, isAnonym: Bool, sessionPassword: String, sessionBackground: String, completion: @escaping (Bool) -> Void) {
        let createdAt = Timestamp(date: Date())
        let expiresAt: Timestamp?

        if let timeRemains = timeRemains, timeRemains > 0 {
            let expirationDate = Date().addingTimeInterval(TimeInterval(timeRemains))
            expiresAt = Timestamp(date: expirationDate)
        } else {
            expiresAt = nil
        }

        let newSession = Session(id: sessionId, createdBy: createdBy, createdAt: createdAt, timerInitialTime: createdAt, timerExpiresDate: expiresAt, isTimerActive: isTimerActive, sessionName: sessionName, isAnonym: isAnonym, boards: [], sessionPassword: sessionPassword, sessionBackground: sessionBackground)
        
        do {
            try db.collection("sessions").document(sessionId).setData(from: newSession) { error in
                if let error = error {
                    print("Error creating session: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            print("Error creating session: \(error)")
            completion(false)
        }
    }

    func joinSession(sessionId: String, sessionPassword: String, completion: @escaping (Bool) -> Void) {
        let sessionRef = db.collection("sessions").document(sessionId)
        sessionRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let session = try? document.data(as: Session.self) else {
                completion(false)
                return
            }

            let currentTime = Timestamp(date: Date())
            
            if sessionPassword == session.sessionPassword {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func fetchBoards(for sessionId: String, completion: @escaping (Result<Session, Error>) -> Void) {
        let sessionRef = db.collection("sessions").document(sessionId)
        
        sessionRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = documentSnapshot, document.exists,
                  let session = try? document.data(as: Session.self) else {
                let error = NSError(domain: "SessionNotFound", code: 0, userInfo: [NSLocalizedDescriptionKey: "Session not found or failed to decode session data."])
                completion(.failure(error))
                return
            }
            completion(.success(session))
        }
    }


    func updateBoardInFirestore(sessionId: String, updatedBoards: [Board], completion: @escaping (Bool) -> Void) {
        let sessionRef = db.collection("sessions").document(sessionId)
        
        let updatedBoardsData = updatedBoards.map { try! Firestore.Encoder().encode($0) }
        
        sessionRef.updateData([
            "boards": updatedBoardsData
        ]) { error in
            if let error = error {
                print("Error updating boards: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }




    func addBoard(to sessionId: String, board: Board, completion: @escaping (Bool) -> Void) {
        let sessionRef = db.collection("sessions").document(sessionId)
        sessionRef.updateData([
            "boards": FieldValue.arrayUnion([try! Firestore.Encoder().encode(board)])
        ]) { error in
            if let error = error {
                print("Error adding board: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getSession(byId sessionId: String, completion: @escaping (Session?, Error?) -> Void) {
        db.collection("sessions").document(sessionId).getDocument { document, error in
            if let document = document, document.exists {
                let session = try? document.data(as: Session.self)
                completion(session, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getSessionSettings(byId sessionId: String, completion: @escaping (Session?, Error?) -> Void) {
        let db = Firestore.firestore()
        let sessionRef = db.collection("sessions").document(sessionId)
        
        sessionRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = documentSnapshot, document.exists,
                  let session = try? document.data(as: Session.self) else {
                let error = NSError(domain: "SessionNotFound", code: 0, userInfo: [NSLocalizedDescriptionKey: "Session not found or failed to decode session data."])
                completion(nil, error)
                return
            }
            
            completion(session, nil)
        }
    }

    func addSettingToSession(byId sessionId: String, isAnonymous: Bool, isTimerActive: Bool, timerMinutes: Int, timeRemains: Int?,  allowUserChange: Bool, completion: @escaping  (Bool) -> Void) {
        
        getSession(byId: sessionId) { [weak self] session, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting session: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard var session = session else {
                print("Session not found.")
                completion(false)
                return
            }
            
            session.isAnonym = isAnonymous
            session.isTimerActive = isTimerActive
            session.allowUserChange = allowUserChange
            session.timeRemains = timeRemains

            
            if let timeRemains = timeRemains, let initialTime = session.timerInitialTime {
                let initialDate = initialTime.dateValue()
                
                let newExpiresDate = initialDate.addingTimeInterval(TimeInterval(timeRemains))
                session.timerExpiresDate = Timestamp(date: newExpiresDate)
            } else {
                
                
                if timerMinutes > 0 {
                    let currentDate = Date()
                    session.timerInitialTime = Timestamp(date: currentDate)
                    session.timerExpiresDate = Timestamp(date: currentDate.addingTimeInterval(TimeInterval(timerMinutes)))
                } else {
                    session.timerInitialTime = nil
                    session.timerExpiresDate = nil
                }
            }
            
            do {
                try db.collection("sessions").document(sessionId).setData(from: session) { error in
                    if let error = error {
                        print("Error updating session: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Session successfully updated.")
                        completion(true)
                    }
                }
            } catch {
                print("Error encoding session: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
        

    func addCardToSession(sessionId: String, boardIndex: Int, newCard: Card, completion: @escaping (Bool) -> Void) {
        getSession(byId: sessionId) { session, error in
            if let session = session {
                var updatedBoards = session.boards
                if boardIndex < updatedBoards.count {
                    var board = updatedBoards[boardIndex]
                    board.cards.append(newCard)
                    updatedBoards[boardIndex] = board
                    
                    let db = Firestore.firestore()
                    let encoder = Firestore.Encoder()
                    let boardsData = updatedBoards.map { try! encoder.encode($0) }
                    
                    db.collection("sessions").document(sessionId).updateData([
                        "boards": boardsData
                    ]) { error in
                        if let error = error {
                            print("Error updating session: \(error)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    print("Board index \(boardIndex) is out of range")
                    completion(false)
                }
            } else {
                print("Session does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
    
    func deleteBoard(sessionId: String, boardIndex: Int, completion: @escaping (Result<Void, Error>) -> Void) {
         let sessionRef = db.collection("sessions").document(sessionId)
         
         sessionRef.getDocument { (document, error) in
             if let error = error {
                 completion(.failure(error))
                 return
             }
             
             guard let document = document, document.exists else {
                 completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Session document does not exist"])))
                 return
             }
             
             do {
                 var session = try document.data(as: Session.self)
                 
                 guard boardIndex < session.boards.count else {
                     completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Board index out of bounds"])))
                     return
                 }
                 
                 session.boards.remove(at: boardIndex)
                 
                 try sessionRef.setData(from: session) { error in
                     if let error = error {
                         completion(.failure(error))
                     } else {
                         completion(.success(()))
                     }
                 }
             } catch {
                 completion(.failure(error))
             }
         }
     }
    
    func deleteCardFromSession(sessionId: String, boardIndex: Int, cardId: String, completion: @escaping (Bool) -> Void) {
        getSession(byId: sessionId) { session, error in
            if let session = session {
                var updatedBoards = session.boards
                if boardIndex < updatedBoards.count {
                    var board = updatedBoards[boardIndex]
                    if let cardIndex = board.cards.firstIndex(where: { $0.id == cardId }) {
                        board.cards.remove(at: cardIndex)
                        updatedBoards[boardIndex] = board
                        
                        let db = Firestore.firestore()
                        let encoder = Firestore.Encoder()
                        let boardsData = updatedBoards.map { try! encoder.encode($0) }
                        
                        db.collection("sessions").document(sessionId).updateData([
                            "boards": boardsData
                        ]) { error in
                            if let error = error {
                                print("Error updating session: \(error)")
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                    } else {
                        print("Card with ID \(cardId) not found in board")
                        completion(false)
                    }
                } else {
                    print("Board index \(boardIndex) is out of range")
                    completion(false)
                }
            } else {
                print("Session does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }

    func updateCardNameInBoard(sessionId: String, boardIndex: Int, cardId: String, newCardDescription: String, completion: @escaping (Bool) -> Void) {
        getSession(byId: sessionId) { session, error in
            if let session = session {
                var updatedBoards = session.boards
                if boardIndex < updatedBoards.count {
                    var board = updatedBoards[boardIndex]
                    if let cardIndex = board.cards.firstIndex(where: { $0.id == cardId }) {
                        board.cards[cardIndex].description = newCardDescription
                        updatedBoards[boardIndex] = board
                        
                        let db = Firestore.firestore()
                        let encoder = Firestore.Encoder()
                        let boardsData = updatedBoards.map { try! encoder.encode($0) }
                        
                        db.collection("sessions").document(sessionId).updateData([
                            "boards": boardsData
                        ]) { error in
                            if let error = error {
                                print("Error updating session: \(error)")
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                    } else {
                        print("Card with ID \(cardId) not found in board")
                        completion(false)
                    }
                } else {
                    print("Board index \(boardIndex) is out of range")
                    completion(false)
                }
            } else {
                print("Session does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }

    
    func reorderCardsInSession(sessionId: String, boardIndex: Int, newCardOrder: [Card], completion: @escaping (Bool) -> Void) {
        getSession(byId: sessionId) { session, error in
            if let session = session {
                var updatedBoards = session.boards
                if boardIndex < updatedBoards.count {
                    var board = updatedBoards[boardIndex]
                    board.cards = newCardOrder
                    updatedBoards[boardIndex] = board
                    
                    let db = Firestore.firestore()
                    let encoder = Firestore.Encoder()
                    let boardsData = updatedBoards.map { try! encoder.encode($0) }
                    
                    db.collection("sessions").document(sessionId).updateData([
                        "boards": boardsData
                    ]) { error in
                        if let error = error {
                            print("Error updating session: \(error)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    print("Board index \(boardIndex) is out of range")
                    completion(false)
                }
            } else {
                print("Session does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }

    func saveUserSession(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let deviceID = DeviceManager.shared.deviceID
        let docRef = db.collection("Users").document(deviceID)

        docRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                var sessions = document.get("sessions") as? [[String: Any]] ?? []
                if !sessions.contains(where: { $0["sessionId"] as? String == user.sessionId }) {
                    let newUserSession: [String: Any] = [
                        "sessionId": user.sessionId,
                        "sessionName": user.sessionName,
                        "userName": user.userName,
                        "backgroundImage": user.backgroundImage,
                        "createdTime": user.createdTime
                    ]
                    sessions.append(newUserSession)
                    docRef.updateData(["sessions": sessions]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                } else {
                    completion(.success(()))
                }
            } else {
                let newUserSession: [String: Any] = [
                    "sessionId": user.sessionId,
                    "sessionName": user.sessionName,
                    "userName": user.userName,
                    "backgroundImage": user.backgroundImage,
                    "createdTime": user.createdTime
                ]
                docRef.setData(["sessions": [newUserSession]]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    func fetchSessionIdsForUser(completion: @escaping (Result<[User], Error>) -> Void) {
        let deviceID = DeviceManager.shared.deviceID
        let docRef = db.collection("Users").document(deviceID)
        
        docRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])
                completion(.failure(error))
                return
            }
            
            let sessionData = document.get("sessions") as? [[String: Any]] ?? []
            let users = sessionData.compactMap { data -> User? in
                guard let sessionId = data["sessionId"] as? String,
                      let sessionName = data["sessionName"] as? String,
                      let userName = data["userName"] as? String,
                      let backgroundImage = data["backgroundImage"] as? String,
                      let createdTime = data["createdTime"] as? Timestamp else { return nil }
                return User(sessionId: sessionId, sessionName: sessionName, userName: userName, backgroundImage: backgroundImage, createdTime: createdTime)
            }
            completion(.success(users))
        }
    }
}


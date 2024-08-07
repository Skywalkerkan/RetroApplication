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
    
    func createSession(sessionId: String, createdBy: String, timeRemains: Int?, sessionName: String, isAnonym: Bool, completion: @escaping (Bool) -> Void) {
        let createdAt = Timestamp(date: Date())
        let expiresAt: Timestamp?

        if let timeRemains = timeRemains, timeRemains > 0 {
            let expirationDate = Date().addingTimeInterval(TimeInterval(timeRemains))
            expiresAt = Timestamp(date: expirationDate)
        } else {
            expiresAt = nil
        }

        let newSession = Session(id: sessionId, createdBy: createdBy, createdAt: createdAt, expiresAt: expiresAt, sessionName: sessionName, isAnonym: isAnonym, boards: [])

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

    
    func getSessionExpiration(sessionId: String, completion: @escaping (Result<Date, Error>) -> Void) {
        let sessionRef = db.collection("sessions").document(sessionId)
        
        sessionRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let expiresAt = document.get("expiresAt") as? Timestamp {
                    completion(.success(expiresAt.dateValue()))
                } else {
                    completion(.failure(NSError(domain: "ExpirationNotFound", code: 0, userInfo: nil)))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "SessionNotFound", code: 0, userInfo: nil)))
            }
        }
    }
    
    func joinSession(sessionId: String, completion: @escaping (Bool) -> Void) {
        let sessionRef = db.collection("sessions").document(sessionId)
        sessionRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let session = try? document.data(as: Session.self) else {
                completion(false)
                return
            }

            let currentTime = Timestamp(date: Date())
            
            if let expiresAt = session.expiresAt {
                if currentTime.compare(expiresAt) == .orderedAscending {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(true)
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
        let db = Firestore.firestore()
        db.collection("sessions").document(sessionId).getDocument { document, error in
            if let document = document, document.exists {
                let session = try? document.data(as: Session.self)
                completion(session, nil)
            } else {
                completion(nil, error)
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

    func updateCardNameInBoard(sessionId: String, boardIndex: Int, cardId: String, newName: String, completion: @escaping (Bool) -> Void) {
        getSession(byId: sessionId) { session, error in
            if let session = session {
                var updatedBoards = session.boards
                if boardIndex < updatedBoards.count {
                    var board = updatedBoards[boardIndex]
                    if let cardIndex = board.cards.firstIndex(where: { $0.id == cardId }) {
                        board.cards[cardIndex].description = newName
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


}


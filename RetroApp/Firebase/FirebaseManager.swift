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
    
    func createSession(sessionId: String, createdBy: String, timeRemains: Int?, sessionName: String, completion: @escaping (Bool) -> Void) {
        let createdAt = Timestamp(date: Date())
        let expiresAt: Timestamp?

        if let timeRemains = timeRemains, timeRemains > 0 {
            let expirationDate = Date().addingTimeInterval(TimeInterval(timeRemains))
            expiresAt = Timestamp(date: expirationDate)
        } else {
            expiresAt = nil
        }

        let newSession = Session(id: sessionId, createdBy: createdBy, createdAt: createdAt, expiresAt: expiresAt, sessionName: sessionName, boards: [])

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

    func fetchBoards(for sessionId: String, completion: @escaping (Result<[Board], Error>) -> Void) {
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

            completion(.success(session.boards))
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
}

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
    
    func createSession(sessionId: String, createdBy: String, completion: @escaping (Bool) -> Void) {
        let createdAt = Timestamp(date: Date())
        let expiresAt = Timestamp(date: Date().addingTimeInterval(300))
        let newSession = Session(id: sessionId, createdBy: createdBy, createdAt: createdAt, expiresAt: expiresAt, boards: [])

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
    
    func joinSession(sessionId: String, completion: @escaping (Bool) -> Void) {
        let sessionRef = db.collection("sessions").document(sessionId)
        sessionRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let session = try? document.data(as: Session.self) else {
                completion(false)
                return
            }

            let currentTime = Timestamp(date: Date())
            if currentTime.compare(session.expiresAt) == .orderedAscending {
                //Session valid hala
                completion(true)
            } else {
                //Session expire olması
                completion(false)
            }
        }
    }

    func fetchBoards(for sessionId: String, completion: @escaping ([Board]) -> Void) {
        let sessionRef = db.collection("sessions").document(sessionId)
        sessionRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let session = try? document.data(as: Session.self) else {
                completion([])
                return
            }

            completion(session.boards)
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

//
//  FirebaseManager.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {
    private var db = Firestore.firestore()
    
    func fetchItems(completion: @escaping ([RetroItem]) -> Void) {
        db.collection("retroItems").order(by: "timestamp", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                completion([])
                return
            }
            
            let items = documents.compactMap { queryDocumentSnapshot -> RetroItem? in
                return try? queryDocumentSnapshot.data(as: RetroItem.self)
            }
            completion(items)
        }
    }
    
    func addItem(_ item: RetroItem, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try db.collection("retroItems").addDocument(from: item)
            completion(.success(()))
        } catch let error {
            print("Error adding document: \(error)")
            completion(.failure(error))
        }
    }
    
    func deleteItem(_ item: RetroItem, completion: @escaping (Result<Void, Error>) -> Void) {
        if let itemID = item.id {
            db.collection("retroItems").document(itemID).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}

//
//  MainViewModel.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class MainViewModel: ObservableObject {
    @Published var items: [RetroItem] = []
    private var db = Firestore.firestore()
    
    func fetchItems() {
        db.collection("retroItems").order(by: "timestamp", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.items = documents.compactMap { queryDocumentSnapshot -> RetroItem? in
                return try? queryDocumentSnapshot.data(as: RetroItem.self)
            }
        }
    }
    
    func addItem(_ item: RetroItem) {
        do {
            _ = try db.collection("retroItems").addDocument(from: item)
        } catch let error {
            print("Error adding document: \(error)")
        }
    }
    
    func deleteItem(_ item: RetroItem) {
        if let itemID = item.id {
            db.collection("retroItems").document(itemID).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
    }
}

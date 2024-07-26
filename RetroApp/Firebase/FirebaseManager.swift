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
    
    func fetchItems(completion: @escaping (Result<[RetroItem], Error>) -> Void) {
        db.collection("retroItems")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion(.success([]))
                    return
                }
                
                do {
                    let items = try documents.compactMap { queryDocumentSnapshot -> RetroItem? in
                        return try queryDocumentSnapshot.data(as: RetroItem.self)
                    }
                    completion(.success(items))
                } catch {
                    print("Error decoding documents: \(error)")
                    completion(.failure(error))
                }
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
    
    func addPanelWithBoardsAndItems(_ panelName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let newPanel = Panel(id: nil, name: panelName, boards: [])
        
        do {
            let panelRef = try db.collection("panels").addDocument(from: newPanel)
            
            let boardLists = [
                BoardList(id: UUID().uuidString, name: "List 1", items: [
                    ListItem(name: "Item 1", description: "Description for Item 1", dueDate: Date()),
                    ListItem(name: "Item 2", description: "Description for Item 2", dueDate: Date()),
                    ListItem(name: "Item 3", description: "Description for Item 3", dueDate: Date())
                ]),
                BoardList(id: UUID().uuidString, name: "List 2", items: [
                    ListItem(name: "Item 4", description: "Description for Item 4", dueDate: Date()),
                    ListItem(name: "Item 5", description: "Description for Item 5", dueDate: Date()),
                    ListItem(name: "Item 6", description: "Description for Item 6", dueDate: Date())
                ]),
                BoardList(id: UUID().uuidString, name: "List 3", items: [
                    ListItem(name: "Item 7", description: "Description for Item 7", dueDate: Date()),
                    ListItem(name: "Item 8", description: "Description for Item 8", dueDate: Date()),
                    ListItem(name: "Item 9", description: "Description for Item 9", dueDate: Date())
                ])
            ]
            
            let boards = [
                Board(id: UUID().uuidString, name: "Board 1", list: boardLists[0]),
                Board(id: UUID().uuidString, name: "Board 2", list: boardLists[1]),
                Board(id: UUID().uuidString, name: "Board 3", list: boardLists[2])
            ]
            
            let group = DispatchGroup()
            var boardAdditionError: Error?
            
            for board in boards {
                group.enter()
                var newBoard = board
                newBoard.id = db.collection("panels").document(panelRef.documentID).collection("boards").document().documentID
                do {
                    try panelRef.collection("boards").document(newBoard.id!).setData(from: newBoard) { error in
                        if let error = error {
                            boardAdditionError = error
                        }
                        group.leave()
                    }
                } catch let error {
                    boardAdditionError = error
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                if let error = boardAdditionError {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
            
        } catch let error {
            completion(.failure(error))
        }
    }

    
    func fetchPanels(completion: @escaping (Result<[Panel], Error>) -> Void) {
        db.collection("panels").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let panels = querySnapshot?.documents.compactMap { document -> Panel? in
                    return try? document.data(as: Panel.self)
                }
                completion(.success(panels ?? []))
            }
        }
    }
    
    func fetchBoards(for panelID: String, completion: @escaping (Result<[Board], Error>) -> Void) {
        db.collection("panels").document(panelID).collection("boards").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let boards = querySnapshot?.documents.compactMap { document -> Board? in
                    return try? document.data(as: Board.self)
                }
                completion(.success(boards ?? []))
            }
        }
    }
    
    func fetchLists(for boardID: String, completion: @escaping (Result<BoardList, Error>) -> Void) {
         db.collection("boards").document(boardID).getDocument { (document, error) in
             if let error = error {
                 completion(.failure(error))
             } else if let document = document, document.exists {
                 do {
                     let board = try document.data(as: Board.self)
                     completion(.success(board.list))
                 } catch let error {
                     completion(.failure(error))
                 }
             } else {
                 completion(.failure(NSError(domain: "DocumentError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist."])))
             }
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

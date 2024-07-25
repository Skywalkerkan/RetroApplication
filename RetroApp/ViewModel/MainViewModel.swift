//
//  MainViewModel.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var items: [RetroItem] = []
    private var firebaseManager = FirebaseManager()
    
    func fetchItems() {
        firebaseManager.fetchItems { [weak self] result in
            switch result {
            case .success(let items):
                self?.items = items
            case .failure(let error):
                print("Error adding item: \(error)")
            }
        }
    }
    
    func addItem(_ item: RetroItem) {
        firebaseManager.addItem(item) { [weak self] result in
            switch result {
            case .success:
                self?.fetchItems()
            case .failure(let error):
                print("Error adding item: \(error)")
            }
        }
    }
    
    func deleteItem(_ item: RetroItem) {
        firebaseManager.deleteItem(item) { [weak self] result in
            switch result {
            case .success:
                self?.fetchItems()
            case .failure(let error):
                print("Error deleting item: \(error)")
            }
        }
    }
}

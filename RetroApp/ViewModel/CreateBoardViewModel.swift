//
//  CreateBoardViewModel.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

class CreateBoardViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager()
    
    @Published var errorMessage: String?

    func addItem(_ item: RetroItem) {
        firebaseManager.addItem(item) { result in
            switch result {
            case .success:
                print("Kaydedildi")
                self.errorMessage = nil
            case .failure(let error):
                print("Error adding item: \(error)")
            }
        }
    }
}

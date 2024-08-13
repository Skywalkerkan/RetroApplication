//
//  MainViewModel.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager()
    
    @Published var isItValidId = false
    @Published var userSessions = [User]()
    
    func joinSession(_ sessionId: String, sessionPassword: String, completion: @escaping (Bool) -> Void) {
        firebaseManager.joinSession(sessionId: sessionId, sessionPassword: sessionPassword) { isValidId in
            DispatchQueue.main.async {
                if isValidId {
                    self.isItValidId = true
                    print("Successfully joined session")
                    completion(true)
                } else {
                    self.isItValidId = false
                    print("Session expired or does not exist")
                    completion(false)
                }
            }
        }
    }
    
    func fetchUserSessions() {
        firebaseManager.fetchSessionIdsForUser { result in
            switch result {
            case .success(let user):
                print("Başarılı")
                DispatchQueue.main.async {
                    self.userSessions = user
                }
            case .failure(let error):
                print("hatalı")
                print(error)
            }
        }
    }
}

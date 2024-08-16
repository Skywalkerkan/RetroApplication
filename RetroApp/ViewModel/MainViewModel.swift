//
//  MainViewModel.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    var firebaseManager = FirebaseManager()
    
    @Published var isItValidId = false
    @Published var error: Error?
    @Published var userSessions = [User]()
    
    func joinSession(_ sessionId: String, sessionPassword: String, completion: @escaping (Bool) -> Void) {
        firebaseManager.joinSession(sessionId: sessionId, sessionPassword: sessionPassword) { result in
            switch result {
            case .success(let isValid):
                if isValid {
                    self.isItValidId = true
                    print("Successfully joined session")
                    completion(true)
                } else {
                    self.isItValidId = false
                    print("Session can not be found")
                    completion(false)
                }
            case .failure(let error):
                self.error = error
                completion(false)
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
    
    func deleteUserSession(for sessionId: String) {
        firebaseManager.deleteForUserSession(for: sessionId) { result in
            switch result {
            case .success(_):
                print("")
            case .failure(let error):
                print(error)
            }
        }
    }
}

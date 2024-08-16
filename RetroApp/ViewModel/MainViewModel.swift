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
        firebaseManager.joinSession(sessionId: sessionId, sessionPassword: sessionPassword) { [weak self] result in
            switch result {
            case .success(let isValid):
                DispatchQueue.main.async {
                    if isValid {
                        self?.isItValidId = true
                        print("Successfully joined session")
                        completion(true)
                    } else {
                        self?.isItValidId = false
                        print("Session cannot be found")
                        completion(false)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                    completion(false)
                }
            }
        }
    }
    
    func fetchUserSessions() {
        firebaseManager.fetchSessionIdsForUser { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    print("Successfully fetched user")
                    self?.userSessions = user
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
    func deleteUserSession(for sessionId: String) {
        firebaseManager.deleteForUserSession(for: sessionId) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    print("Successfully deleted user session")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
}

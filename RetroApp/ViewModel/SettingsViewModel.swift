//
//  SettingsViewModel.swift
//  RetroApp
//
//  Created by Erkan on 8.08.2024.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager()
    @Published var error: Error?
    @Published var isItValidId = false
    @Published var session: Session?

    func getSessionSettings(sessionId: String, completion: @escaping (Bool) -> Void) {
        firebaseManager.getSessionSettings(byId: sessionId) { session, error in
            if let session = session {
                self.session = session
                completion(true)
            } else {
                self.error = NSError(
                    domain: "SettingsViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to get session settings: \(error?.localizedDescription ?? "Unknown error")"]
                )
                completion(false)
            }
        }
    }
    
    func addSettingsToSession(sessionId: String, isAnonymous: Bool, isTimerActive: Bool, timer: Int, timeRemains: Int?, allowUserChange: Bool) {
        firebaseManager.addSettingToSession(byId: sessionId, isAnonymous: isAnonymous, isTimerActive: isTimerActive, timerMinutes: timer, timeRemains: timeRemains, allowUserChange: allowUserChange) { result in
            if result {
                print("Successfully updated settings")
            } else {
                self.error = NSError(
                    domain: "SettingsViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to update settings"]
                )
            }
        }
    }
    
    func deleteSession(for sessionId: String) {
        firebaseManager.deleteSession(byId: sessionId) { result in
            switch result {
            case .success(_):
                print("Successfully deleted session")
            case .failure(let error):
                self.error = NSError(
                    domain: "SettingsViewModelErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to delete session: \(error.localizedDescription)"]
                )
            }
        }
    }
}

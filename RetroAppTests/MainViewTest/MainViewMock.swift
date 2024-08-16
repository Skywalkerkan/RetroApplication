//
//  MainViewMock.swift
//  RetroAppTests
//
//  Created by Erkan on 16.08.2024.
//

import XCTest
@testable import RetroApp

class MainViewMock: FirebaseManager {
    var joinSessionResult: Result<Bool, Error>?
    var fetchSessionIdsResult: Result<[User], Error>?
    var deleteUserSessionResult: Result<Void, Error>?

    override func joinSession(sessionId: String, sessionPassword: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let result = joinSessionResult {
            completion(result)
        }
    }

    override func fetchSessionIdsForUser(completion: @escaping (Result<[User], Error>) -> Void) {
        if let result = fetchSessionIdsResult {
            completion(result)
        }
    }

    override func deleteForUserSession(for sessionId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = deleteUserSessionResult {
            completion(result)
        }
    }
}

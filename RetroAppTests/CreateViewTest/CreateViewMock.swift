//
//  CreateViewMock.swift
//  RetroAppTests
//
//  Created by Erkan on 16.08.2024.
//

import XCTest
@testable import RetroApp

class CreateViewMock: FirebaseManager {
    var shouldReturnError = false
    var shouldReturnValidResult = false

    override func createSession(sessionId: String, createdBy: String, timeRemains: Int?, isTimerActive: Bool, sessionName: String, isAnonym: Bool, sessionPassword: String, sessionBackground: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.testError))
        } else {
            completion(.success(()))
        }
    }

    override func joinSession(sessionId: String, sessionPassword: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.testError))
        } else {
            completion(.success(shouldReturnValidResult))
        }
    }

    override func addBoard(to sessionId: String, board: Board, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.testError))
        } else {
            completion(.success(()))
        }
    }

    override func saveUserSession(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.testError))
        } else {
            completion(.success(()))
        }
    }
}

// Mock Error for testing
enum MockError: Error {
    case testError
}

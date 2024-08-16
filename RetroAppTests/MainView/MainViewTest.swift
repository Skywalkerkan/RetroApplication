//
//  MainViewTest.swift
//  RetroAppTests
//
//  Created by Erkan on 15.08.2024.
//

import XCTest
import Combine
@testable import RetroApp

class MockFirebaseManager: FirebaseManager {
    
    var mockJoinSessionResult: Result<Bool, Error>?
    var mockFetchSessionIdsResult: Result<[User], Error>?
    
    override func joinSession(sessionId: String, sessionPassword: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let result = mockJoinSessionResult {
            completion(result)
        }
    }
    
    override func fetchSessionIdsForUser(completion: @escaping (Result<[User], Error>) -> Void) {
        if let result = mockFetchSessionIdsResult {
            completion(result)
        }
    }
}

class MainViewModelTests: XCTestCase {
    
    var viewModel: MainViewModel!
    var mockFirebaseManager: MockFirebaseManager!
    
    override func setUp() {
        super.setUp()
        mockFirebaseManager = MockFirebaseManager()
        viewModel = MainViewModel()
        viewModel.firebaseManager = mockFirebaseManager
    }
    
    override func tearDown() {
        viewModel = nil
        mockFirebaseManager = nil
        super.tearDown()
    }
    
    func testJoinSessionSuccess() {
        let sessionId = "validSessionId"
        let sessionPassword = "validPassword"
        mockFirebaseManager.mockJoinSessionResult = .success(true)
        
        let expectation = XCTestExpectation(description: "Join session succeeds")
        viewModel.joinSession(sessionId, sessionPassword: sessionPassword) { success in
            XCTAssertTrue(success)
            XCTAssertTrue(self.viewModel.isItValidId)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testJoinSessionFailure() {
        let sessionId = "invalidSessionId"
        let sessionPassword = "invalidPassword"
        mockFirebaseManager.mockJoinSessionResult = .success(false)
        
        let expectation = XCTestExpectation(description: "Join session fails")
        viewModel.joinSession(sessionId, sessionPassword: sessionPassword) { success in
            XCTAssertFalse(success)
            XCTAssertFalse(self.viewModel.isItValidId)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchUserSessions_Success() {
        let userSessions = [
            User(sessionId: "1", sessionName: "Session 1", userName: "Erkan", backgroundImage: "1"),
            User(sessionId: "2", sessionName: "Session 2", userName: "Sky", backgroundImage: "2")
        ]
        mockFirebaseManager.mockFetchSessionIdsResult = .success(userSessions)
        
        let expectation = XCTestExpectation(description: "Fetch user sessions succeeds")
        
        viewModel.fetchUserSessions()
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.userSessions.count, 2)
            XCTAssertEqual(self.viewModel.userSessions.first?.userName, "Erkan")
            XCTAssertEqual(self.viewModel.userSessions.first?.sessionId, "Sky")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchUserSessions_Failure() {
        let error = NSError(domain: "TestError", code: 123, userInfo: nil)
        mockFirebaseManager.mockFetchSessionIdsResult = .failure(error)
        
        viewModel.fetchUserSessions()
        
        XCTAssertTrue(viewModel.userSessions.isEmpty)
    }
}


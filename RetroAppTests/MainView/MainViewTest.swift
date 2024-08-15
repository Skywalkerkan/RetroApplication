//
//  MainViewTest.swift
//  RetroAppTests
//
//  Created by Erkan on 15.08.2024.
//

import XCTest
import Combine
import FirebaseFirestore
@testable import RetroApp

class MockFirebaseManager: FirebaseManager {
    var shouldReturnValidId = true
    var mockUserSessions: [User] = []
    
    override func joinSession(sessionId: String, sessionPassword: String, completion: @escaping (Bool) -> Void) {
        completion(shouldReturnValidId)
    }
    
    override func fetchSessionIdsForUser(completion: @escaping (Result<[User], Error>) -> Void) {
        completion(.success(mockUserSessions))
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
        mockFirebaseManager.shouldReturnValidId = true
        
        let expectation = self.expectation(description: "JoinSession")
        viewModel.joinSession("validSessionId", sessionPassword: "password") { isSuccess in
            print(isSuccess)
            XCTAssertTrue(isSuccess)
            XCTAssertTrue(self.viewModel.isItValidId)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testJoinSessionFailure() {
        mockFirebaseManager.shouldReturnValidId = false
        
        let expectation = self.expectation(description: "JoinSession")
        viewModel.joinSession("invalidSessionId", sessionPassword: "password") { isSuccess in
            XCTAssertFalse(isSuccess)
            XCTAssertFalse(self.viewModel.isItValidId)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchUserSessions() {
        let mockUsers = [
            User(sessionId: "1", sessionName: "Session 1", userName: "Alice", backgroundImage: "image1", createdTime: Timestamp()),
            User(sessionId: "2", sessionName: "Session 2", userName: "Bob", backgroundImage: "image2", createdTime: Timestamp())
        ]
        mockFirebaseManager.mockUserSessions = mockUsers
        
        let expectation = self.expectation(description: "FetchUserSessions")
        viewModel.fetchUserSessions()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.userSessions, mockUsers)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

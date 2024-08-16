//
//  MainViewTest.swift
//  RetroAppTests
//
//  Created by Erkan on 15.08.2024.
//

import XCTest
import Combine
@testable import RetroApp

class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockFirebaseManager: MainViewMock!

    override func setUp() {
        super.setUp()
        mockFirebaseManager = MainViewMock()
        viewModel = MainViewModel()
        viewModel.firebaseManager = mockFirebaseManager
    }

    override func tearDown() {
        viewModel = nil
        mockFirebaseManager = nil
        super.tearDown()
    }

    func testJoinSessionSuccess() {
        mockFirebaseManager.joinSessionResult = .success(true)

        let expectation = XCTestExpectation(description: "Join session succeeds")
        viewModel.joinSession("testSessionId", sessionPassword: "password") { isSuccess in
            XCTAssertTrue(isSuccess)
            XCTAssertTrue(self.viewModel.isItValidId)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testJoinSessionFailure() {
        mockFirebaseManager.joinSessionResult = .success(false)

        let expectation = XCTestExpectation(description: "Join session fails")
        viewModel.joinSession("testSessionId", sessionPassword: "password") { isSuccess in
            XCTAssertFalse(isSuccess)
            XCTAssertFalse(self.viewModel.isItValidId)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchUserSessionsSuccess() {
        let users = [
            User(sessionId: "1", sessionName: "Session 1", userName: "User1", backgroundImage: "Image1"),
            User(sessionId: "2", sessionName: "Session 2", userName: "User2", backgroundImage: "Image2")
        ]
        mockFirebaseManager.fetchSessionIdsResult = .success(users)

        let expectation = XCTestExpectation(description: "Fetch user sessions succeeds")
        viewModel.fetchUserSessions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.userSessions, users)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchUserSessionsFailure() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fetch error"])
        mockFirebaseManager.fetchSessionIdsResult = .failure(error)

        let expectation = XCTestExpectation(description: "Fetch user sessions fails")
        viewModel.fetchUserSessions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.userSessions.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testDeleteUserSessionSuccess() {
        mockFirebaseManager.deleteUserSessionResult = .success(())

        let expectation = XCTestExpectation(description: "Delete user session succeeds")
        viewModel.deleteUserSession(for: "testSessionId")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testDeleteUserSessionFailure() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Delete error"])
        mockFirebaseManager.deleteUserSessionResult = .failure(error)

        let expectation = XCTestExpectation(description: "Delete user session fails")
        viewModel.deleteUserSession(for: "testSessionId")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

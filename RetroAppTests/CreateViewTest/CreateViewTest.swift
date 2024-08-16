//
//  CreateViewTest.swift
//  RetroAppTests
//
//  Created by Erkan on 16.08.2024.
//

import XCTest
import FirebaseFirestore
@testable import RetroApp

class CreateBoardViewModelTests: XCTestCase {
    var viewModel: CreateBoardViewModel!
    var createViewMock: CreateViewMock!

    override func setUp() {
        super.setUp()
        createViewMock = CreateViewMock()
        viewModel = CreateBoardViewModel()
        viewModel.firebaseManager = createViewMock
    }

    override func tearDown() {
        viewModel = nil
        createViewMock = nil
        super.tearDown()
    }

    func testCreateSessionSuccess() {
        createViewMock.shouldReturnError = false
        viewModel.createSession(createdBy: "TestUser", sessionId: "123", sessionPassword: "password", timer: 10, isTimerActive: true, sessionName: "Test Session", isAnonym: false, sessionBackground: "background")
        XCTAssertNil(viewModel.error)
    }

    func testCreateSessionFailure() {
        createViewMock.shouldReturnError = true
        viewModel.createSession(createdBy: "TestUser", sessionId: "123", sessionPassword: "password", timer: 10, isTimerActive: true, sessionName: "Test Session", isAnonym: false, sessionBackground: "background")
        XCTAssertNotNil(viewModel.error)
    }

    func testJoinSessionSuccess() {
        createViewMock.shouldReturnError = false
        createViewMock.shouldReturnValidResult = true
        viewModel.joinSession(sessionId: "123", sessionPassword: "password")
        XCTAssertNil(viewModel.error)
    }

    func testJoinSessionFailure() {
        createViewMock.shouldReturnError = true
        viewModel.joinSession(sessionId: "123", sessionPassword: "password")
        XCTAssertNotNil(viewModel.error)
    }

    func testCreateBoardSuccess() {
        createViewMock.shouldReturnError = false
        let timestamp = Timestamp(date: Date())
        let card = Card(id: "ABCDEF", description: "CardDetail", userName: "Erkan", createdAt: timestamp)
        let board = Board(id: "idExample", name: "Went Well", cards: [card])
        viewModel.createBoard(sessionId: "123", board: board)
        XCTAssertNil(viewModel.error)
    }

    func testCreateBoardFailure() {
        createViewMock.shouldReturnError = true
        let timestamp = Timestamp(date: Date())
        let card = Card(id: "ABCDEF", description: "CardDetail", userName: "Erkan", createdAt: timestamp)
        let board = Board(id: "1", name: "Test Board", cards: [card])
        viewModel.createBoard(sessionId: "123", board: board)
        XCTAssertNotNil(viewModel.error)
    }

    func testSaveUserSessionSuccess() {
        createViewMock.shouldReturnError = false
        let user = User(sessionId: "1", sessionName: "Test Session", userName: "Test User", backgroundImage: "backgroundImage", createdTime: Timestamp(date: Date()))
        viewModel.saveUserSession(user: user)
        XCTAssertNil(viewModel.error)
    }

    func testSaveUserSessionFailure() {
        createViewMock.shouldReturnError = true
        let user = User(sessionId: "1", sessionName: "Test Session", userName: "Test User", backgroundImage: "backgroundImage", createdTime: Timestamp(date: Date()))
        viewModel.saveUserSession(user: user)
        XCTAssertNotNil(viewModel.error)
    }
}

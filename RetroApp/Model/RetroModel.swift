//
//  RetroModel.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Session: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var createdBy: String
    var createdAt: Timestamp
    var timerInitialTime: Timestamp?
    var timerExpiresDate: Timestamp?
    var isTimerActive: Bool?
    var sessionName: String?
    var isAnonym: Bool
    var allowUserChange: Bool?
    var boards: [Board]
    var sessionPassword: String
    var sessionBackground: String
}

struct Board: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var name: String
    var cards: [Card]
}

struct Card: Identifiable, Hashable, Codable {
    var id: String
    var description: String
    var userName: String
    var createdAt: Timestamp?

    init(id: String = UUID().uuidString, description: String, userName: String, createdAt: Timestamp = Timestamp()) {
        self.id = id
        self.description = description
        self.userName = userName
        self.createdAt = createdAt
    }
}

struct User: Identifiable, Hashable, Codable {
    var id: String? { sessionId }
    var sessionId: String
    var sessionName: String
    var userName: String
    var backgroundImage: String
    var createdTime: Timestamp = Timestamp()
}


/*
struct ListItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var dueDate: Date?
    var likes: Int
}*/

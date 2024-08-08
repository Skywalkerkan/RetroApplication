//
//  RetroModel.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Session: Identifiable, Codable {
    @DocumentID var id: String?
    var createdBy: String
    var createdAt: Timestamp
    var timerInitialTime: Timestamp?
    var timerExpiresDate: Timestamp?
    var sessionName: String?
    var isAnonym: Bool
    var boards: [Board]
    var sessionPassword: String
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
/*
struct ListItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var dueDate: Date?
    var likes: Int
}*/

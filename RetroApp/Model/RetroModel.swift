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
    var expiresAt: Timestamp?
    var boards: [Board]
}

struct Board: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var name: String
    var cards: [Card]
}

struct Card: Identifiable, Hashable, Codable {
    var id: String
    var name: String

    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
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

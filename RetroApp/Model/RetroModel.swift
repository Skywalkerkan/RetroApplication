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
    @DocumentID var id: String? = UUID().uuidString
    var createdBy: String
    var createdAt: Timestamp
    var expiresAt: Timestamp?
    var boards: [Board]
}

struct Board: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var cards: [Card]
}

struct Card: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var items: [ListItem]
}

struct ListItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var dueDate: Date?
    var likes: Int
}

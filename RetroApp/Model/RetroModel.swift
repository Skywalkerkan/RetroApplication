//
//  RetroModel.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import Foundation
import FirebaseFirestoreSwift

struct RetroItem: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var description: String
    var timestamp: Date = Date()
    var category: RetroCategory
}

struct BoardItem: Identifiable,Codable {
    @DocumentID var id: String? = UUID().uuidString
    var cardTitle: String
}

enum RetroCategory: String, Codable, CaseIterable {
    case toDo = "ToDo"
    case beingDone = "Being Done"
    case done = "Done"
}
/*
// Panel Modeli
struct Panel: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var boards: [Board]
}

// Board Modeli
struct Board: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var lists: [BoardList]
}

// List Modeli
struct BoardList: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var items: [String] // Her item bir string olabilir. İstersen, daha karmaşık bir yapı da kullanabilirsin.
}

// Item Modeli (Opsiyonel, eğer liste itemları daha karmaşık olacaksa)
struct ListItem: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var dueDate: Date?
}
*/


struct Panel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var boards: [Board]
}

struct Board: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var list: BoardList
}

struct BoardList: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var items: [ListItem]
}

struct ListItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var description: String?
    var dueDate: Date?
}

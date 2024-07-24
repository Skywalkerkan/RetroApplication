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

enum RetroCategory: String, Codable, CaseIterable {
    case toDo = "ToDo"
    case beingDone = "Being Done"
    case done = "Done"
}



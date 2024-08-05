//
//  Session.swift
//  RetroApp
//
//  Created by Erkan on 5.08.2024.
//

import Foundation
import SwiftData

@Model
class SessionPanel {
    var sessionId: String
    var sessionName: String
    var userName: String

    init(sessionId: String = "", sessionName: String = "", userName: String = "") {
        self.sessionId = sessionId
        self.sessionName = sessionName
        self.userName = userName
    }
}

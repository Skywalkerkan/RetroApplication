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
    var sessionPassword: String
    var sessionCreatedTime: Date
    var sessionBackground: String
    var userName: String

    init(sessionId: String = "", sessionName: String = "",
         sessionPassword: String = "", sessionCreatedTime: Date = Date(), userName: String = "", sessionBackground: String = "1") {
        self.sessionId = sessionId
        self.sessionName = sessionName
        self.sessionPassword = sessionPassword
        self.sessionCreatedTime = sessionCreatedTime
        self.userName = userName
        self.sessionBackground = sessionBackground
    }
}

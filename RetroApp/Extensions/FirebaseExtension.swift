//
//  FirebaseExtension.swift
//  RetroApp
//
//  Created by Erkan on 7.08.2024.
//

import FirebaseFirestore
import SwiftUI

extension Timestamp {
    func toString() -> String {
        let date = self.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}


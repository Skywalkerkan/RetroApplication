//
//  DeviceManager.swift
//  RetroApp
//
//  Created by Erkan on 13.08.2024.
//

import Foundation

struct DeviceManager {
    static let shared = DeviceManager()

    private let deviceIDKey = "deviceID"

    var deviceID: String {
        if let deviceID = UserDefaults.standard.string(forKey: deviceIDKey) {
            return deviceID
        } else {
            let newDeviceID = UUID().uuidString
            UserDefaults.standard.set(newDeviceID, forKey: deviceIDKey)
            return newDeviceID
        }
    }

    func initializeDeviceID() {
        _ = deviceID
    }
}

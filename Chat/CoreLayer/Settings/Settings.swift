//
//  Settings.swift
//  Chat
//
//  Created by Anastasia Shmakova on 13.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class Settings: SettingsProtocol {
    private let userDefaults: UserDefaults
    
    var theme: String? {
        get {
            return userDefaults.string(forKey: themeKey)
        }
        set {
            userDefaults.set(newValue, forKey: themeKey)
        }
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

private let themeKey = "ThemeKey"

//
//  ThemeManager.swift
//  Chat
//
//  Created by Anastasia Shmakova on 07.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class ThemeManager {
    private let defaults = UserDefaults.standard
    private var theme: Theme?
    
    static var shared = ThemeManager()
    
    var currentTheme: Theme {
        get {
            if let theme = theme {
                return theme
            }
            let storedTheme = defaults.string(forKey: themeKey).flatMap { Theme(rawValue: $0) } ?? .classic
            self.theme = storedTheme
            return storedTheme
        }
        set {
            self.theme = newValue
            defaults.set(newValue.rawValue, forKey: themeKey)
        }
    }

    private init() {}
}

private let themeKey = "ThemeKey"

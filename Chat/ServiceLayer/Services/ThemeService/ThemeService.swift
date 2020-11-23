//
//  ThemeService.swift
//  Chat
//
//  Created by Anastasia Shmakova on 07.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class ThemeService: ThemeServiceProtocol {
    private let settings: SettingsProtocol
    private let queue = DispatchQueue(label: "ThemeManager", qos: .userInitiated)
    private let mainQueue = DispatchQueue.main
    private var theme: Theme?
    
    var currentTheme: Theme {
        get {
            if let theme = theme {
                return theme
            }
            let storedTheme = settings.theme.flatMap { Theme(rawValue: $0) } ?? .classic
            self.theme = storedTheme
            return storedTheme
        }
        set {
            queue.async {
                self.settings.theme = newValue.rawValue
                self.mainQueue.async {
                    self.theme = newValue
                }
            }
        }
    }

    init(settings: SettingsProtocol) {
        self.settings = settings
    }
}

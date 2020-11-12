//
//  ThemeModel.swift
//  Chat
//
//  Created by Anastasia Shmakova on 13.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

protocol ThemeModelProtocol {
    var currentTheme: Theme { get set }
}

class ThemeModel: ThemeModelProtocol {
    private let themeService: ThemeServiceProtocol
    
    var currentTheme: Theme {
        get {
            themeService.currentTheme
        }
        set {
            themeService.currentTheme = newValue
        }
    }
    
    init(themeService: ThemeServiceProtocol) {
        self.themeService = themeService
    }
}

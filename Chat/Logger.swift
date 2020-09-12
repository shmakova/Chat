//
//  Logger.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

func log(_ message: String, on: Bool = true) {
    #if DEBUG
    guard on else {
        return
    }
    print(message)
    #endif
}

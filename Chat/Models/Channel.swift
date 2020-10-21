//
//  Channel.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

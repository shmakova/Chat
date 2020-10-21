//
//  MessageCellModel.swift
//  Chat
//
//  Created by Anastasia Shmakova on 30.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

struct MessageCellModel {
    enum Kind {
        case incoming
        case outgoing
    }
    
    let message: Message
    let kind: Kind
}

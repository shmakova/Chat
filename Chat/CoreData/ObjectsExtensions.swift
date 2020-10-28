//
//  ObjectsExtensions.swift
//  Chat
//
//  Created by Anastasia Shmakova on 26.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

extension ChannelDb {
    var about: String {
        let description = "Channel { name: \(String(describing: name)), "
            + "id: \(String(describing: identifier)), "
            + "lastMessage: \(String(describing: lastMessage)), "
            + "lastActivity: \(String(describing: lastActivity)) }"
        let messages = self.messages?.allObjects
            .compactMap { $0 as? MessageDb }
            .map { "\t\t\tMessage { \($0.about) }" }
            .joined(separator: "\n") ?? ""
        return description + messages
    }
    
    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = channel.identifier
        name = channel.name
        lastMessage = channel.lastMessage
        lastActivity = channel.lastActivity
    }
}

extension MessageDb {
    var about: String {
        return "content: \(String(describing: content)), "
            + "id: \(String(describing: identifier)), "
            + "created: \(String(describing: created)), "
            + "senderId: \(String(describing: senderId)), "
            + "senderName: \(String(describing: senderName))"
    }
    
    convenience init(message: Message, in context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = message.identifier
        content = message.content
        created = message.created
        senderId = message.senderId
        senderName = message.senderName
    }
}

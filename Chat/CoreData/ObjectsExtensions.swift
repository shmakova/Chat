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

    var channel: Channel {
        guard let identifier = identifier, let name = name else {
            fatalError()
        }
        return Channel(
            identifier: identifier,
            name: name,
            lastMessage: lastMessage,
            lastActivity: lastActivity
        )
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

    var message: Message {
        guard let identifier = identifier,
            let content = content,
            let created = created,
            let senderId = senderId,
            let senderName = senderName else {
            fatalError()
        }
        return Message(
            identifier: identifier,
            content: content,
            created: created,
            senderId: senderId,
            senderName: senderName
        )
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

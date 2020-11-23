//
//  CoreDataStorage.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStorage: StorageProtocol {
    
    private let coreDataStack: CoreDataStack
    
    var channelsFetchedResultsController: NSFetchedResultsController<ChannelDb> {
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        let sort = NSSortDescriptor(key: "lastActivity", ascending: false)
        request.sortDescriptors = [sort]
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    var messagesFetchedResultsController: NSFetchedResultsController<MessageDb> {
        let request: NSFetchRequest<MessageDb> = MessageDb.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sort]
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func saveChannels(_ channels: [Channel]) {
        assert(!Thread.isMainThread)
        coreDataStack.performSave { context in
            channels.forEach {
                let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
                request.predicate = NSPredicate(format: "identifier = %@", $0.identifier)
                guard let fetchedResults = try? context.fetch(request), let channelDb = fetchedResults.first else {
                    _ = ChannelDb(channel: $0, in: context)
                    return
                }
                channelDb.name = $0.name
                channelDb.lastActivity = $0.lastActivity
                channelDb.lastMessage = $0.lastMessage
            }
            let identifiers: [String] = channels.map { $0.identifier }
            let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
            request.predicate = NSPredicate(format: "NOT (identifier IN %@)", identifiers)
            guard let channelsToRemove = try? context.fetch(request) else {
                log("No channels to remove")
                return
            }
            log("Channels to remove \(channelsToRemove)")
            channelsToRemove.forEach { context.delete($0) }
        }
    }
    
    func saveMessages(_ messages: [Message], channel: Channel) {
        assert(!Thread.isMainThread)
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
        coreDataStack.performSave { context in
            guard let fetchedResults = try? context.fetch(request), let channelDb = fetchedResults.first else {
                return
            }
            messages.forEach {
                let request: NSFetchRequest<MessageDb> = MessageDb.fetchRequest()
                request.predicate = NSPredicate(format: "identifier = %@", $0.identifier)
                if let fetchedResults = try? context.fetch(request), fetchedResults.first == nil {
                    let message = MessageDb(message: $0, in: context)
                    message.channel = channelDb
                }
            }
        }
    }
}

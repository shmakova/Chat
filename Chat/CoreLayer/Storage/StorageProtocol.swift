//
//  StorageProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 11.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

protocol StorageProtocol {
    var channelsFetchedResultsController: NSFetchedResultsController<ChannelDb> { get }
    var messagesFetchedResultsController: NSFetchedResultsController<MessageDb> { get }
    
    func saveChannels(_ channels: [Channel])
    func saveMessages(_ messages: [Message], channel: Channel)
}

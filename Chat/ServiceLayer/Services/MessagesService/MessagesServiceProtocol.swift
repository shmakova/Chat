//
//  MessagesServiceProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

protocol MessagesServiceProtocol: class {
    var delegate: NSFetchedResultsControllerDelegate? { get set }
    func addMessagesListener(channel: Channel)
    func removeMessagesListener()
    func addNewMessage(
        channel: Channel,
        message: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func numberOfMessages(for section: Int) -> Int
    func findMessage(at indexPath: IndexPath) -> MessageCellModel
}

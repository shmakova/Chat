//
//  MessagesService.swift
//  Chat
//
//  Created by Anastasia Shmakova on 21.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

final class MessagesService: MessagesServiceProtocol {
    weak var delegate: NSFetchedResultsControllerDelegate?
    
    private let network: NetworkProtocol
    private let storage: StorageProtocol
    private let deviceDataProvider: DeviceDataProviderProtocol
    private let fetchedResultsController: NSFetchedResultsController<MessageDb>
 
    init(
        network: NetworkProtocol,
        storage: StorageProtocol,
        deviceDataProvider: DeviceDataProviderProtocol
    ) {
        self.network = network
        self.storage = storage
        self.deviceDataProvider = deviceDataProvider
        self.fetchedResultsController = storage.messagesFetchedResultsController
    }
    
    func addMessagesListener(channel: Channel) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "channel.identifier = %@",
            channel.identifier
        )
        fetchedResultsController.delegate = delegate
        try? fetchedResultsController.performFetch()
        network.addMessagesListener(
            channel: channel,
            completion: { [weak self] result in
                log("Messages update")
                switch result {
                case let .success(messages):
                    self?.storage.saveMessages(messages, channel: channel)
                case let .failure(error):
                    log("Messages fetch error: \(error)")
                }
            }
        )
    }
    
    func removeMessagesListener() {
        network.removeMessagesListener()
    }
    
    func addNewMessage(
        channel: Channel,
        message: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        network.addNewMessage(channel: channel, message: message, completion: completion)
    }

    func numberOfMessages(for section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func findMessage(at indexPath: IndexPath) -> MessageCellModel {
        let message = fetchedResultsController.object(at: indexPath).message
        return MessageCellModel(
            message: message,
            kind: deviceDataProvider.deviceID == message.senderId ? .outgoing : .incoming
        )
    }
}

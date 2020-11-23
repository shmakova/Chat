//
//  ChannelsService.swift
//  Chat
//
//  Created by Anastasia Shmakova on 21.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

final class ChannelsService: ChannelsServiceProtocol {
    weak var delegate: NSFetchedResultsControllerDelegate?

    private let network: NetworkProtocol
    private let storage: StorageProtocol
    private let fetchedResultsController: NSFetchedResultsController<ChannelDb>
    
    init(network: NetworkProtocol, storage: StorageProtocol) {
        self.network = network
        self.storage = storage
        self.fetchedResultsController = storage.channelsFetchedResultsController
    }
    
    func addChannelsListener() {
        fetchedResultsController.delegate = delegate
        try? fetchedResultsController.performFetch()
        network.addChannelsListener { [weak self] result in
            log("Channels update")
            switch result {
            case let .success(channels):
                self?.storage.saveChannels(channels)
            case let .failure(error):
                log("Channels fetch error: \(error)")
            }
        }
    }
    
    func removeChannelsListener() {
        network.removeChannelsListener()
    }
    
    func addNewChannel(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        network.addNewChannel(name: name, completion: completion)
    }

    func removeChannel(channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        network.removeChannel(channel: channel, completion: completion)
    }

    func numberOfChannels(for section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func findChannel(at indexPath: IndexPath) -> Channel {
        return fetchedResultsController.object(at: indexPath).channel
    }
}

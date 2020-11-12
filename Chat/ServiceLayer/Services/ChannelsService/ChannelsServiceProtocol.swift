//
//  ChannelsServiceProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

protocol ChannelsServiceProtocol: class {
    var delegate: NSFetchedResultsControllerDelegate? { get set }
    func addChannelsListener()
    func removeChannelsListener()
    func addNewChannel(name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeChannel(channel: Channel, completion: @escaping (Result<Void, Error>) -> Void)
    func numberOfChannels(for section: Int) -> Int
    func findChannel(at indexPath: IndexPath) -> Channel
}

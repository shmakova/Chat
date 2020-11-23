//
//  NetworkProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

protocol NetworkProtocol {
    func addNewChannel(name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeChannel(channel: Channel, completion: @escaping (Result<Void, Error>) -> Void)
    func addChannelsListener(completion: @escaping (Result<[Channel], Error>) -> Void)
    func removeChannelsListener()
    func addNewMessage(
        channel: Channel,
        message: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func addMessagesListener(channel: Channel, completion: @escaping (Result<[Message], Error>) -> Void)
    func removeMessagesListener()
}

//
//  FirestoreNetwork.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Firebase
import Foundation

class FirestoreNetwork: NetworkProtocol {
    private let db: Firestore
    private let operationQueue: OperationQueue
    private let deviceDataProvider: DeviceDataProviderProtocol
    
    private lazy var reference = db.collection("channels")
    private var channelsListeners: [ListenerRegistration] = []
    private var messagesListeners: [ListenerRegistration] = []
    
    init(
        db: Firestore,
        operationQueue: OperationQueue,
        deviceDataProvider: DeviceDataProviderProtocol
    ) {
        self.db = db
        self.operationQueue = operationQueue
        self.deviceDataProvider = deviceDataProvider
    }
    
    func addNewChannel(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        reference.addDocument(data: ["name": name]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func removeChannel(channel: Channel, completion: @escaping (Result<Void, Error>) -> Void) {
        reference.document(channel.identifier).delete(
            completion: { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        )
    }
    
    func addChannelsListener(completion: @escaping (Result<[Channel], Error>) -> Void) {
        guard channelsListeners.isEmpty else {
            return
        }
        let listener = reference.limit(to: 500)
            .addSnapshotListener { [weak self] (snapshot, error) in
                log("Channels update")
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let self = self else { return }
                self.operationQueue.addOperation {
                    let channels = snapshot?.documents
                        .compactMap { $0.channel }
                        .sorted(by: { ($0.lastActivity ?? .distantPast) > ($1.lastActivity ?? .distantPast) }) ?? []
                    completion(.success(channels))
                }
        }
        channelsListeners.append(listener)
    }
    
    func removeChannelsListener() {
        for listener in channelsListeners {
            listener.remove()
        }
        channelsListeners.removeAll()
    }
    
    func addNewMessage(channel: Channel, message: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = [
            "content": message,
            "created": Timestamp(date: Date()),
            "senderId": deviceDataProvider.deviceID,
            "senderName": "Shmakova Anastasia"
        ]
        reference.document(channel.identifier)
            .collection("messages")
            .addDocument(data: data) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
        }
    }
    
    func addMessagesListener(channel: Channel, completion: @escaping (Result<[Message], Error>) -> Void) {
        guard messagesListeners.isEmpty else {
            return
        }
        let listener = reference.document(channel.identifier)
            .collection("messages")
            .order(by: "created")
            .limit(toLast: 50)
            .addSnapshotListener { [weak self] (snapshot, error) in
                log("Messages update")
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let self = self else { return }
                self.operationQueue.addOperation {
                    let messages = snapshot?.documents.compactMap { $0.message } ?? []
                    completion(.success(messages))
                }
        }
        messagesListeners.append(listener)
    }
    
    func removeMessagesListener() {
        for listener in messagesListeners {
            listener.remove()
        }
        messagesListeners.removeAll()
    }
}

private extension QueryDocumentSnapshot {
    var channel: Channel? {
        let channelData = data()
        guard let name = channelData["name"] as? String, !name.isEmpty else {
            return nil
        }
        return Channel(
            identifier: documentID,
            name: name,
            lastMessage: channelData["lastMessage"] as? String,
            lastActivity: (channelData["lastActivity"] as? Timestamp)?.dateValue()
        )
    }
    
    var message: Message? {
        let messageData = data()
        guard let content = messageData["content"] as? String, !content.isEmpty,
            let created = (messageData["created"] as? Timestamp)?.dateValue(),
            let senderId = messageData["senderId"] as? String,
            let senderName = messageData["senderName"] as? String else {
                return nil
        }
        return Message(
            identifier: documentID,
            content: content,
            created: created,
            senderId: senderId,
            senderName: senderName
        )
    }
}

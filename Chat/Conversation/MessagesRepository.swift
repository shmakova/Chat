//
//  MessagesRepository.swift
//  Chat
//
//  Created by Anastasia Shmakova on 21.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Firebase
import Foundation

final class MessagesRepository {
    private let deviceIDProvider: DeviceIDProvider
    private let operationQueue = OperationQueue()
    private let mainQueue = OperationQueue.main
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    private var listeners: [ListenerRegistration] = []
    
    init(deviceIDProvider: DeviceIDProvider = DeviceIDProvider()) {
        self.deviceIDProvider = deviceIDProvider
        operationQueue.name = "MessagesRepository"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
    }
    
    func addMessagesListener(channel: Channel, completion: @escaping (Result<[MessageCellModel], Error>) -> Void) {
        guard listeners.isEmpty else {
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
                self?.operationQueue.addOperation {
                    let messages = snapshot?.documents
                        .compactMap { $0.message }
                        .map {
                            MessageCellModel(
                                message: $0,
                                kind: self?.deviceIDProvider.deviceID == $0.senderId ? .outgoing : .incoming
                            )
                    }
                    self?.mainQueue.addOperation {
                        completion(.success(messages ?? []))
                    }
                }
        }
        listeners.append(listener)
    }
    
    func removeMessagesListener() {
        for listener in listeners {
            listener.remove()
        }
        listeners.removeAll()
    }
    
    func addNewMessage(
        channel: Channel,
        message: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let data: [String: Any] = [
            "content": message,
            "created": Timestamp(date: Date()),
            "senderId": deviceIDProvider.deviceID,
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
}

private extension QueryDocumentSnapshot {
    var message: Message? {
        let messageData = data()
        guard let content = messageData["content"] as? String, !content.isEmpty,
            let created = (messageData["created"] as? Timestamp)?.dateValue(),
            let senderId = messageData["senderId"] as? String,
            let senderName = messageData["senderName"] as? String else {
                log("Invalid message data \(messageData)")
                return nil
        }
        return Message(
            content: content,
            created: created,
            senderId: senderId,
            senderName: senderName
        )
    }
}

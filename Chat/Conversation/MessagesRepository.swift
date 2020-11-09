//
//  MessagesRepository.swift
//  Chat
//
//  Created by Anastasia Shmakova on 21.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Firebase
import Foundation

final class MessagesRepository {
    private let deviceIDProvider: DeviceIDProvider
    private let operationQueue = OperationQueue()
    private let mainQueue = OperationQueue.main
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private lazy var coreDataStack = CoreDataStack.shared
    
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
                guard let self = self else { return }
                self.operationQueue.addOperation {
                    let messages = snapshot?.documents.compactMap { $0.message } ?? []
                    self.saveMessages(messages, channel: channel)
                    let messageCellModels = messages.map {
                        MessageCellModel(
                            message: $0,
                            kind: self.deviceIDProvider.deviceID == $0.senderId ? .outgoing : .incoming
                        )
                    }
                    self.mainQueue.addOperation {
                        completion(.success(messageCellModels))
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
    
    private func saveMessages(_ messages: [Message], channel: Channel) {
        assert(!Thread.isMainThread)
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
        coreDataStack.performSave { context in
            guard let fetchedResults = try? context.fetch(request), let channelDb = fetchedResults.first else {
                return
            }
            channelDb.messages?
                .compactMap { $0 as? NSManagedObject }
                .forEach { context.delete($0) }
            let messagesDb = messages.map { MessageDb(message: $0, in: context) }
            channelDb.messages = NSSet(array: messagesDb)
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

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
    weak var delegate: NSFetchedResultsControllerDelegate?
    
    private let deviceIDProvider: DeviceIDProvider
    private let operationQueue = OperationQueue()
    private let fetchedResultsController: NSFetchedResultsController<MessageDb>
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private lazy var coreDataStack = CoreDataStack.shared
    
    private var listeners: [ListenerRegistration] = []
    
    init(deviceIDProvider: DeviceIDProvider = DeviceIDProvider()) {
        self.deviceIDProvider = deviceIDProvider
        operationQueue.name = "MessagesRepository"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
        let request: NSFetchRequest<MessageDb> = MessageDb.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sort]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    func addMessagesListener(channel: Channel) {
        guard listeners.isEmpty else {
            return
        }
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "channel.identifier = %@",
            channel.identifier
        )
        fetchedResultsController.delegate = delegate
        try? fetchedResultsController.performFetch()
        let listener = reference.document(channel.identifier)
            .collection("messages")
            .order(by: "created")
            .limit(toLast: 50)
            .addSnapshotListener { [weak self] (snapshot, error) in
                log("Messages update")
                if let error = error {
                    log("Messages fetch error: \(error)")
                    return
                }
                guard let self = self else { return }
                self.operationQueue.addOperation {
                    let messages = snapshot?.documents.compactMap { $0.message } ?? []
                    self.saveMessages(messages, channel: channel)
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

    func numberOfMessages(for section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func findMessage(at indexPath: IndexPath) -> MessageCellModel {
        let message = fetchedResultsController.object(at: indexPath).message
        return MessageCellModel(
            message: message,
            kind: deviceIDProvider.deviceID == message.senderId ? .outgoing : .incoming
        )
    }
    
    private func saveMessages(_ messages: [Message], channel: Channel) {
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

//
//  ChannelsRepository.swift
//  Chat
//
//  Created by Anastasia Shmakova on 21.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Firebase
import Foundation

final class ChannelsRepository {
    weak var delegate: NSFetchedResultsControllerDelegate?

    private let operationQueue = OperationQueue()
    private let fetchedResultsController: NSFetchedResultsController<ChannelDb>

    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private lazy var coreDataStack = CoreDataStack.shared

    private var listeners: [ListenerRegistration] = []
    
    init() {
        operationQueue.name = "ChannelsRepository"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        let sort = NSSortDescriptor(key: "lastActivity", ascending: false)
        request.sortDescriptors = [sort]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    func addChannelsListener() {
        guard listeners.isEmpty else {
            return
        }
        fetchedResultsController.delegate = delegate
        try? fetchedResultsController.performFetch()
        let listener = reference.limit(to: 500)
            .addSnapshotListener { [weak self] (snapshot, error) in
                log("Channels update")
                if let error = error {
                    log("Channels fetch error: \(error)")
                    return
                }
                guard let self = self else { return }
                self.operationQueue.addOperation {
                    let channels = snapshot?.documents
                        .compactMap { $0.channel }
                        .sorted(by: { ($0.lastActivity ?? .distantPast) > ($1.lastActivity ?? .distantPast) }) ?? []
                    self.saveChannels(channels)
                }
        }
        listeners.append(listener)
    }
    
    func removeChannelsListener() {
        for listener in listeners {
            listener.remove()
        }
        listeners.removeAll()
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

    func numberOfChannels(for section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func findChannel(at indexPath: IndexPath) -> Channel {
        return fetchedResultsController.object(at: indexPath).channel
    }

    private func saveChannels(_ channels: [Channel]) {
        assert(!Thread.isMainThread)
        coreDataStack.performSave { context in
            channels.forEach {
                let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
                request.predicate = NSPredicate(format: "identifier = %@", $0.identifier)
                guard let fetchedResults = try? context.fetch(request), let channelDb = fetchedResults.first else {
                    _ = ChannelDb(channel: $0, in: context)
                    return
                }
                channelDb.name = $0.name
                channelDb.lastActivity = $0.lastActivity
                channelDb.lastMessage = $0.lastMessage
            }
            let identifiers: [String] = channels.map { $0.identifier }
            let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
            request.predicate = NSPredicate(format: "NOT (identifier IN %@)", identifiers)
            guard let channelsToRemove = try? context.fetch(request) else {
                log("No channels to remove")
                return
            }
            log("Channels to remove \(channelsToRemove)")
            channelsToRemove.forEach { context.delete($0) }
        }
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
}

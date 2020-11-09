//
//  ChannelsRepository.swift
//  Chat
//
//  Created by Anastasia Shmakova on 21.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Firebase
import Foundation

final class ChannelsRepository {
    private let operationQueue = OperationQueue()
    private let mainQueue = OperationQueue.main
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private lazy var coreDataStack = CoreDataStack.shared
    
    private var listeners: [ListenerRegistration] = []
    
    init() {
        operationQueue.name = "ChannelsRepository"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
    }
    
    func addChannelsListener(completion: @escaping (Result<[Channel], Error>) -> Void) {
        guard listeners.isEmpty else {
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
                    self.saveChannels(channels)
                    self.mainQueue.addOperation {
                        completion(.success(channels))
                    }
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
    
    private func saveChannels(_ channels: [Channel]) {
        assert(!Thread.isMainThread)
        coreDataStack.performSave { context in
            channels.forEach {
                _ = ChannelDb(channel: $0, in: context)
            }
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

//
//  CoreAssembly.swift
//  Chat
//
//  Created by Anastasia Shmakova on 11.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Firebase
import Foundation

protocol CoreAssemblyProtocol {
    var coreDataStorage: StorageProtocol { get }
    var firestoreNetwork: NetworkProtocol { get }
    var deviceDataProvider: DeviceDataProviderProtocol { get }
    var fileStorage: FileStorageProtocol { get }
    var settings: SettingsProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var coreDataStorage: StorageProtocol = CoreDataStorage(coreDataStack: CoreDataStack.shared)
    
    lazy var firestoreNetwork: NetworkProtocol = FirestoreNetwork(
        db: Firestore.firestore(),
        operationQueue: operationQueue,
        deviceDataProvider: deviceDataProvider
    )
    
    lazy var deviceDataProvider: DeviceDataProviderProtocol = DeviceDataProvider()
    
    lazy var fileStorage: FileStorageProtocol = FileStorage(fileManager: FileManager.default)
    
    lazy var settings: SettingsProtocol = Settings(userDefaults: UserDefaults.standard)
    
    private lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "Core Queue"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()
}

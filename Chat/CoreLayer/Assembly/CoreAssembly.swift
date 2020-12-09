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
    var requestSender: RequestSenderProtocol { get }
    var imagesRequestConfig: RequestConfig<ImagesParser> { get }
    var imageLoader: ImageLoaderProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var coreDataStorage: StorageProtocol = CoreDataStorage(coreDataStack: CoreDataStack.shared)
    
    lazy var firestoreNetwork: NetworkProtocol = FirestoreNetwork(
        db: Firestore.firestore(),
        operationQueue: serialOperationQueue,
        deviceDataProvider: deviceDataProvider
    )
    
    lazy var deviceDataProvider: DeviceDataProviderProtocol = DeviceDataProvider()
    
    lazy var fileStorage: FileStorageProtocol = FileStorage(fileManager: .default)
    
    lazy var settings: SettingsProtocol = Settings(userDefaults: .standard)
    
    lazy var imagesRequestConfig: RequestConfig<ImagesParser> = RequestConfig<ImagesParser>(
        request: ImagesRequest(
            apiKey: Environment.pixabayApiKey,
            host: Environment.pixabayApiHost
        ),
        parser: ImagesParser()
    )
    
    lazy var requestSender: RequestSenderProtocol = RequestSender(session: .shared)
    
    lazy var imageLoader: ImageLoaderProtocol = ImageLoader(
        operationQueue: concurrentOperationQueue,
        mainQueue: .main
    )
    
    private lazy var serialOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "Core Queue"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()
    
    private lazy var concurrentOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "Core Concurrent Queue"
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()
}

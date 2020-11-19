//
//  ServicesAssembly.swift
//  Chat
//
//  Created by Anastasia Shmakova on 11.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

protocol ServicesAssemblyProtocol {
    var channelsService: ChannelsServiceProtocol { get }
    var messagesService: MessagesServiceProtocol { get }
    var gcdProfileDataService: ProfileDataServiceProtocol { get }
    var operationProfileDataService: ProfileDataServiceProtocol { get }
    var themeService: ThemeServiceProtocol { get }
    var imagesService: ImagesServiceProtocol { get }
}

class ServicesAssembly: ServicesAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var channelsService: ChannelsServiceProtocol = ChannelsService(
        network: coreAssembly.firestoreNetwork,
        storage: coreAssembly.coreDataStorage
    )
    
    lazy var messagesService: MessagesServiceProtocol = MessagesService(
        network: coreAssembly.firestoreNetwork,
        storage: coreAssembly.coreDataStorage,
        deviceDataProvider: coreAssembly.deviceDataProvider
    )
    
    lazy var gcdProfileDataService: ProfileDataServiceProtocol = GCDProfileDataService(
        fileProfileDataService: fileProfileDataService
    )
    
    lazy var operationProfileDataService: ProfileDataServiceProtocol = OperationProfileDataService(
        fileProfileDataService: fileProfileDataService
    )
    
    lazy var themeService: ThemeServiceProtocol = ThemeService(
        settings: coreAssembly.settings
    )
    
    lazy var imagesService: ImagesServiceProtocol = ImagesService(
        requestSender: coreAssembly.requestSender,
        imagesRequestConfig: coreAssembly.imagesRequestConfig,
        imageLoader: coreAssembly.imageLoader
    )
    
    private lazy var fileProfileDataService: ProfileDataServiceProtocol = FileProfileDataService(
        fileStorage: coreAssembly.fileStorage
    )
}

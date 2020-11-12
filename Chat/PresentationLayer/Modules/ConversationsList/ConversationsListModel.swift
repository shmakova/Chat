//
//  ConversationsListModel.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

protocol ConversationsListModelProtocol {
    var currentTheme: Theme { get set }
    func addChannelsListener(delegate: NSFetchedResultsControllerDelegate)
    func removeChannelsListener()
    func addNewChannel(name: String)
    func removeChannel(channel: Channel)
    func numberOfChannels(for section: Int) -> Int
    func findChannel(at indexPath: IndexPath) -> Channel
}

class ConversationsListModel: ConversationsListModelProtocol {
    private let themeService: ThemeServiceProtocol
    private let channelsService: ChannelsServiceProtocol
    
    var currentTheme: Theme {
        get {
            themeService.currentTheme
        }
        set {
            themeService.currentTheme = newValue
        }
    }
    
    init(themeService: ThemeServiceProtocol, channelsService: ChannelsServiceProtocol) {
        self.themeService = themeService
        self.channelsService = channelsService
    }
    
    func addChannelsListener(delegate: NSFetchedResultsControllerDelegate) {
        channelsService.delegate = delegate
        channelsService.addChannelsListener()
    }
    
    func removeChannelsListener() {
        channelsService.removeChannelsListener()
    }
    
    func addNewChannel(name: String) {
        channelsService.addNewChannel(
            name: name,
            completion: { result in
                switch result {
                case .success:
                    break
                case let .failure(error):
                    log("Add new channel error: \(error)")
                }
            }
        )
    }
    
    func removeChannel(channel: Channel) {
        channelsService.removeChannel(
            channel: channel,
            completion: { result in
                switch result {
                case .success:
                    break
                case let .failure(error):
                    log("Add new channel error: \(error)")
                }
            }
        )
    }
    
    func numberOfChannels(for section: Int) -> Int {
        return channelsService.numberOfChannels(for: section)
    }
    
    func findChannel(at indexPath: IndexPath) -> Channel {
        return channelsService.findChannel(at: indexPath)
    }
}

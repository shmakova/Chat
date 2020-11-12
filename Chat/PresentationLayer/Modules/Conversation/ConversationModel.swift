//
//  ConversationModel.swift
//  Chat
//
//  Created by Anastasia Shmakova on 13.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import Foundation

protocol ConversationModelProtocol {
    var currentTheme: Theme { get }
    func addMessagesListener(channel: Channel, delegate: NSFetchedResultsControllerDelegate)
    func removeMessagesListener()
    func addNewMessage(channel: Channel, message: String)
    func numberOfMessages(for section: Int) -> Int
    func findMessage(at indexPath: IndexPath) -> MessageCellModel
}

class ConversationModel: ConversationModelProtocol {
    private let themeService: ThemeServiceProtocol
    private let messagesService: MessagesServiceProtocol
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    init(themeService: ThemeServiceProtocol, messagesService: MessagesServiceProtocol) {
        self.themeService = themeService
        self.messagesService = messagesService
    }
    
    func addMessagesListener(channel: Channel, delegate: NSFetchedResultsControllerDelegate) {
        messagesService.delegate = delegate
        messagesService.addMessagesListener(channel: channel)
    }
    
    func removeMessagesListener() {
        messagesService.removeMessagesListener()
    }
    
    func addNewMessage(channel: Channel, message: String) {
        messagesService.addNewMessage(
            channel: channel,
            message: message,
            completion: { result in
                switch result {
                case .success:
                    break
                case let .failure(error):
                    log("Add new message error: \(error)")
                }
            }
        )
    }
    
    func numberOfMessages(for section: Int) -> Int {
        return messagesService.numberOfMessages(for: section)
    }
    
    func findMessage(at indexPath: IndexPath) -> MessageCellModel {
        return messagesService.findMessage(at: indexPath)
    }
}

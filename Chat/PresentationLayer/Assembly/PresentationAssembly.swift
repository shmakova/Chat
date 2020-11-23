//
//  PresentationAssembly.swift
//  Chat
//
//  Created by Anastasia Shmakova on 11.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation
import UIKit

protocol PresentationAssemblyProtocol {
    func conversationsListViewController() -> UIViewController
    func conversationViewController(channel: Channel) -> UIViewController
    func profileViewController() -> UIViewController
    func themesViewController(onThemePicked: @escaping (Theme) -> Void) -> UIViewController
}

class PresentationAssembly: PresentationAssemblyProtocol {

    private let servicesAssembly: ServicesAssemblyProtocol
    
    init(servicesAssembly: ServicesAssemblyProtocol) {
        self.servicesAssembly = servicesAssembly
    }
    
    func conversationsListViewController() -> UIViewController {
        guard let vc = ConversationsListViewController.storyboardInstance() as? ConversationsListViewController else {
            fatalError()
        }
        vc.model = conversationsListModel()
        vc.presentationAssembly = self
        return vc
    }
    
    func conversationViewController(channel: Channel) -> UIViewController {
        guard let vc = ConversationViewController.storyboardInstance() as? ConversationViewController else {
            fatalError()
        }
        vc.channel = channel
        vc.model = conversationModel()
        return vc
    }
    
    func profileViewController() -> UIViewController {
        guard let vc = ProfileViewController.storyboardInstance() as? ProfileViewController else {
            fatalError()
        }
        vc.modalPresentationStyle = .pageSheet
        vc.model = profileModel()
        return vc
    }
    
    func themesViewController(onThemePicked: @escaping (Theme) -> Void) -> UIViewController {
        guard let vc = ThemesViewController.storyboardInstance() as? ThemesViewController else {
            fatalError()
        }
        vc.onThemePicked = onThemePicked
        vc.model = themeModel()
        return vc
    }
    
    private func conversationsListModel() -> ConversationsListModelProtocol {
        return ConversationsListModel(
            themeService: servicesAssembly.themeService,
            channelsService: servicesAssembly.channelsService
        )
    }
    
    private func conversationModel() -> ConversationModelProtocol {
        return ConversationModel(
            themeService: servicesAssembly.themeService,
            messagesService: servicesAssembly.messagesService
        )
    }
    
    private func themeModel() -> ThemeModelProtocol {
        return ThemeModel(themeService: servicesAssembly.themeService)
    }
    
    private func profileModel() -> ProfileModelProtocol {
        return ProfileModel(
            themeService: servicesAssembly.themeService,
            gcdProfileDataService: servicesAssembly.gcdProfileDataService,
            operationProfileDataService: servicesAssembly.operationProfileDataService
        )
    }
}

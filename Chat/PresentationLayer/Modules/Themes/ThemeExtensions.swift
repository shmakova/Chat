//
//  ThemeExtensions.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

extension Theme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .classic, .day:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var activityIndicatorStyle: UIActivityIndicatorView.Style {
        switch self {
        case .classic, .day:
            return .gray
        case .dark:
            return .white
        }
    }
    
    var colors: Colors {
        switch self {
        case .classic:
            return Colors(
                backgroundColor: .white,
                navigationBarColor: UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1),
                primaryTextColor: .black,
                secondaryTextColor: UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6),
                settingsIconColor: UIColor(red: 0.329, green: 0.329, blue: 0.345, alpha: 0.65),
                settingsBackgroundColor: UIColor(red: 0.098, green: 0.21, blue: 0.379, alpha: 1),
                incomingMessageColor: UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1),
                incomingMessageTextColor: .black,
                incomingDateTextColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
                outgoingMessageColor: UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1),
                outgoingMessageTextColor: .black,
                outgoingDateTextColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
                profileSaveButtonBackgroundColor: UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1),
                sendMessageViewBackgroundColor: UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
            )
        case .day:
            return Colors(
                backgroundColor: .white,
                navigationBarColor: UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1),
                primaryTextColor: .black,
                secondaryTextColor: UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6),
                settingsIconColor: UIColor(red: 0.329, green: 0.329, blue: 0.345, alpha: 0.65),
                settingsBackgroundColor: UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1),
                incomingMessageColor: UIColor(red: 0.918, green: 0.922, blue: 0.929, alpha: 1),
                incomingMessageTextColor: .black,
                incomingDateTextColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
                outgoingMessageColor: UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1),
                outgoingMessageTextColor: .white,
                outgoingDateTextColor: .white,
                profileSaveButtonBackgroundColor: UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1),
                sendMessageViewBackgroundColor: UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
            )
        case .dark:
            return Colors(
                backgroundColor: .black,
                navigationBarColor: UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1),
                primaryTextColor: .white,
                secondaryTextColor: UIColor(red: 0.553, green: 0.553, blue: 0.576, alpha: 1),
                settingsIconColor: .white,
                settingsBackgroundColor: .black,
                incomingMessageColor: UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1),
                incomingMessageTextColor: .white,
                incomingDateTextColor: .white,
                outgoingMessageColor: UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1),
                outgoingMessageTextColor: .white,
                outgoingDateTextColor: .white,
                profileSaveButtonBackgroundColor: UIColor(red: 0.106, green: 0.106, blue: 0.106, alpha: 1),
                sendMessageViewBackgroundColor: .black
            )
        }
    }
}

struct Colors {
    let backgroundColor: UIColor
    let navigationBarColor: UIColor
    let primaryTextColor: UIColor
    let secondaryTextColor: UIColor
    let settingsIconColor: UIColor
    let settingsBackgroundColor: UIColor
    let incomingMessageColor: UIColor
    let incomingMessageTextColor: UIColor
    let incomingDateTextColor: UIColor
    let outgoingMessageColor: UIColor
    let outgoingMessageTextColor: UIColor
    let outgoingDateTextColor: UIColor
    let profileSaveButtonBackgroundColor: UIColor
    let sendMessageViewBackgroundColor: UIColor
}

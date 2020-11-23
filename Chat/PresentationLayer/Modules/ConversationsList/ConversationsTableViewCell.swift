//
//  ConversationsTableViewCell.swift
//  Chat
//
//  Created by Anastasia Shmakova on 29.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ConversationsTableViewCell: UITableViewCell, ConfigurableView, ThemeableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var currentTheme: Theme = .classic
    
    func configure(with model: Channel) {
        nameLabel.text = model.name
        dateLabel.text = model.lastActivity?.formatted
        if let message = model.lastMessage, !message.isEmpty {
            messageLabel.text = message
            messageLabel.textColor = currentTheme.colors.secondaryTextColor
            dateLabel.isHidden = false
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.textColor = .red
            dateLabel.isHidden = true
        }
    }
    
    func applyTheme(_ theme: Theme) {
        self.currentTheme = theme
        nameLabel.textColor = theme.colors.primaryTextColor
        messageLabel.textColor = theme.colors.secondaryTextColor
        dateLabel.textColor = theme.colors.secondaryTextColor
    }
}

private let messageFontSize = CGFloat(13.0)

private extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var formatted: String {
        let dateFormatter = DateFormatter()
        if isToday {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        }
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self)
    }
}

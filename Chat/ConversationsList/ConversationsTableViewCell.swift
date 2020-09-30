//
//  ConversationsTableViewCell.swift
//  Chat
//
//  Created by Anastasia Shmakova on 29.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ConversationsTableViewCell: UITableViewCell, ConfigurableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func configure(with model: ConversationCellModel) {
        nameLabel.text = model.name
        dateLabel.text = model.date.formatted
        if model.message.isEmpty {
            messageLabel.text = "No messages yet"
            messageLabel.textColor = .red
            dateLabel.isHidden = true
        } else {
            messageLabel.text = model.message
            messageLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
            dateLabel.isHidden = false
        }
        if model.isOnline {
            backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.2)
        } else {
            backgroundColor = .clear
        }
        if model.hasUnreadMessages {
            messageLabel.font = .boldSystemFont(ofSize: messageFontSize)
        } else {
            messageLabel.font = .systemFont(ofSize: messageFontSize)
        }
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

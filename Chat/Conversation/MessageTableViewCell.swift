//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Anastasia Shmakova on 30.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, ConfigurableView, ThemeableView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var currentTheme: Theme = .classic
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.layer.cornerRadius = 8
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.message.content
        dateLabel.text = model.message.created.formatted
        switch model.kind {
        case .incoming:
            stackView.alignment = .leading
            messageContainerView.backgroundColor = currentTheme.colors.incomingMessageColor
            messageLabel.textColor = currentTheme.colors.incomingMessageTextColor
            nameLabel.textColor = currentTheme.colors.incomingMessageTextColor
            nameLabel.isHidden = false
            nameLabel.text = model.message.senderName
            dateLabel.textColor = currentTheme.colors.incomingDateTextColor
        case .outgoing:
            stackView.alignment = .trailing
            messageContainerView.backgroundColor = currentTheme.colors.outgoingMessageColor
            messageLabel.textColor = currentTheme.colors.outgoingMessageTextColor
            nameLabel.textColor = currentTheme.colors.outgoingMessageTextColor
            nameLabel.isHidden = true
            nameLabel.text = ""
            dateLabel.textColor = currentTheme.colors.outgoingDateTextColor
        }
    }
    
    func applyTheme(_ theme: Theme) {
        self.currentTheme = theme
    }
}

private extension Date {
    var formatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

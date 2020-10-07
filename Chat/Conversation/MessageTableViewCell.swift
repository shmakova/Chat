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
    
    private var currentTheme: Theme = .classic
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.layer.cornerRadius = 8
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        switch model.kind {
        case .incoming:
            stackView.alignment = .leading
            messageContainerView.backgroundColor = currentTheme.colors.incomingMessageColor
            messageLabel.textColor = currentTheme.colors.incomingMessageTextColor
        case .outgoing:
            stackView.alignment = .trailing
            messageContainerView.backgroundColor = currentTheme.colors.outgoingMessageColor
            messageLabel.textColor = currentTheme.colors.outgoingMessageTextColor
        }
    }
    
    func applyTheme(_ theme: Theme) {
        self.currentTheme = theme
    }
}

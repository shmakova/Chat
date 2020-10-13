//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Anastasia Shmakova on 30.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.layer.cornerRadius = 8
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        switch model.kind {
        case .incoming:
            stackView.alignment = .leading
            messageContainerView.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
        case .outgoing:
            stackView.alignment = .trailing
            messageContainerView.backgroundColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
        }
    }
}

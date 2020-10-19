//
//  ThemeButton.swift
//  Chat
//
//  Created by Anastasia Shmakova on 07.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ThemeButton: UIButton, ConfigurableView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var incomingMessageImageView: UIImageView!
    @IBOutlet weak var outgoingMessageImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("ThemeButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.isUserInteractionEnabled = false
        setTitle(nil, for: .normal)
    }
    
    func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        if isSelected {
            containerView.layer.borderWidth = 3
            containerView.layer.borderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        } else {
            setupDefaultBorder()
        }
    }
    
    func configure(with model: ThemeButtonModel) {
        setupDefaultBorder()
        button.setTitle(model.title, for: .normal)
        containerView.backgroundColor = model.backgroundColor
        incomingMessageImageView.tintColor = model.incomingMessageColor
        outgoingMessageImageView.tintColor = model.outgoingMessageColor
    }
    
    private func setupDefaultBorder() {
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
    }
}

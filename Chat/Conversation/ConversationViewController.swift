//
//  ConversationViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 29.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

final class ConversationViewController: UIViewController {
    private let cellIdentifier = String(describing: MessageTableViewCell.self)
    private let repository = MessagesRepository()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageBackgroundView: UIView!
    
    private let currentTheme = ThemeManager.shared.currentTheme
    private var messages: [MessageCellModel] = []
    
    var channel: Channel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationItem.title = channel?.name
        tableView.register(
            UINib(nibName: String(describing: MessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: cellIdentifier
        )
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        messageTextField.rightView = makeSendButton()
        messageTextField.rightViewMode = .whileEditing
        messageTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        applyTheme(currentTheme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let channel = channel else {
            return
        }
        repository.addMessagesListener(channel: channel, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(messages):
                self.messages = messages
                self.tableView.reloadData()
                self.tableView.scrollToBottom()
            case let .failure(error):
                log("Messages fetch error: \(error)")
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        repository.removeMessagesListener()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    @objc private func dismissKeyboard() {
        messageTextField.resignFirstResponder()
    }
    
    private func makeSendButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "SendIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -18, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(messageTextField.frame.size.width - 18), y: 5, width: 18, height: 18)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }
    
    @objc private func sendMessage() {
        guard let channel = channel, let message = messageTextField.text, !message.isEmpty  else {
            return
        }
        messageTextField.text = nil
        repository.addNewMessage(
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
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        cell.applyTheme(currentTheme)
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

extension ConversationViewController: ThemeableView {
    func applyTheme(_ theme: Theme) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
        view.backgroundColor = theme.colors.backgroundColor
        sendMessageBackgroundView.backgroundColor = theme.colors.sendMessageViewBackgroundColor
        tableView.backgroundColor = theme.colors.backgroundColor
        tableView.backgroundView?.backgroundColor = theme.colors.backgroundColor
        tableView.reloadData()
    }
}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

extension UITableView {
    func scrollToBottom() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)

            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            guard self.indexPathIsValid(indexPath) else { return }
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}

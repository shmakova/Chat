//
//  ConversationViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 29.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import UIKit

final class ConversationViewController: UIViewController {
    private let cellIdentifier = String(describing: MessageTableViewCell.self)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageBackgroundView: UIView!
    
    var channel: Channel!
    var model: ConversationModelProtocol!
    
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
        applyTheme(model.currentTheme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let channel = channel else {
            return
        }
        model.addMessagesListener(channel: channel, delegate: self)
        tableView.reloadData()
        tableView.scrollToBottom()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        model.removeMessagesListener()
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
        model.addNewMessage(channel: channel, message: message)
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.numberOfMessages(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        cell.applyTheme(model.currentTheme)
        cell.configure(with: model.findMessage(at: indexPath))
        return cell
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.scrollToBottom()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
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

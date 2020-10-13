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
    private var messagesStorage: [MessageCellModel] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(
            UINib(nibName: String(describing: MessageTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: cellIdentifier
        )
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        return tableView
    }()
    
    var selectedName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesStorage = messages.shuffled()
        navigationItem.title = selectedName
        view.addSubview(tableView)
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messagesStorage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: messagesStorage[indexPath.row])
        return cell
    }
}

private let messages: [MessageCellModel] = [
    MessageCellModel(text: "Hi", kind: .outgoing),
    MessageCellModel(text: "Bye", kind: .incoming),
    MessageCellModel(text: "Hello", kind: .outgoing),
    MessageCellModel(text: "Good bye!", kind: .outgoing),
    MessageCellModel(text: "Good morning!", kind: .outgoing),
    MessageCellModel(text: "Japan looks amazing!", kind: .outgoing),
    MessageCellModel(text: "Do you know what time is it?", kind: .incoming),
    MessageCellModel(text: "It’s morning in Tokyo ", kind: .outgoing),
    MessageCellModel(text: "What is the most popular meal in Japan?", kind: .incoming),
    MessageCellModel(text: "Do you like it?", kind: .incoming),
    MessageCellModel(text: "I like it", kind: .outgoing),
    MessageCellModel(text: "I will write you", kind: .outgoing),
    MessageCellModel(text: "Ok, see you", kind: .incoming),
    MessageCellModel(text: "Have a nice day", kind: .incoming),
    MessageCellModel(text: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", kind: .incoming),
    MessageCellModel(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", kind: .outgoing),
    MessageCellModel(text: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis.", kind: .incoming),
    MessageCellModel(text: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.", kind: .outgoing),
    MessageCellModel(text: "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", kind: .incoming),
    MessageCellModel(text: "Where are you?", kind: .outgoing),
    MessageCellModel(text: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.", kind: .incoming),
    MessageCellModel(text: "Voluptate irure aliquip consectetur commodo ex ex.",  kind: .outgoing),
    MessageCellModel(text: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", kind: .outgoing),
    MessageCellModel(text: "Amet enim do laborum tempor nisi aliqua ad adipisicing.", kind: .incoming),
    MessageCellModel(text: "Ex Lorem veniam veniam irure sunt adipisicing culpa.", kind: .outgoing),
    MessageCellModel(text: "Voluptate irure aliquip consectetur commodo ex ex.", kind: .incoming),
    MessageCellModel(text: "Where is the last horcrux?", kind: .outgoing),
    MessageCellModel(text: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", kind: .outgoing),
    MessageCellModel(text: "Verni mne moj dve tyschi sedmoj", kind: .incoming)
]

//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 28.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

final class ConversationsListViewController: UIViewController {
    private let cellIdentifier = String(describing: ConversationsTableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(
            UINib(nibName: String(describing: ConversationsTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: cellIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private var currentTheme: Theme = ThemeManager.shared.currentTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeSettingsButton())
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: makeProfileButton())
        applyTheme(currentTheme)
    }
    
    private func makeProfileButton() -> UIButton {
        let profileButton = UIButton(type: .custom)
        profileButton.setTitleColor(
            UIColor(red: 0.212, green: 0.216, blue: 0.22, alpha: 1),
            for: .normal
        )
        profileButton.setTitle("MD", for: .normal)
        profileButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profileButton.layer.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1).cgColor
        profileButton.layer.cornerRadius = profileButton.bounds.width / 2
        profileButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        return profileButton
    }
    
    private func makeSettingsButton() -> UIButton {
        let settingsButton = UIButton(type: .custom)
        let image = UIImage(named: "SettingsIcon")
        settingsButton.setImage(image, for: .normal)
        settingsButton.tintColor = currentTheme.colors.settingsIconColor
        settingsButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        return settingsButton
    }
    
    @objc private func openProfile(_ sender: Any) {
        guard let profileViewController = ProfileViewController.storyboardInstance() else {
            assertionFailure()
            return
        }
        profileViewController.modalPresentationStyle = .pageSheet
        present(profileViewController, animated: true)
    }
    
    @objc private func openSettings(_ sender: Any) {
        guard let themesViewController = ThemesViewController.storyboardInstance() as? ThemesViewController else {
            assertionFailure()
            return
        }
        // themesViewController.delegate = self
        themesViewController.onThemePicked = { [weak self] in
            self?.applyTheme($0)
        }
        navigationController?.pushViewController(themesViewController, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        conversations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversations[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return conversations[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationsTableViewCell else {
            return UITableViewCell()
        }
        cell.applyTheme(currentTheme)
        cell.configure(with: conversations[indexPath.section].items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = currentTheme.colors.primaryTextColor
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversationViewController =
            ConversationViewController.storyboardInstance() as? ConversationViewController else {
            assertionFailure()
            return
        }
        let conversation = conversations[indexPath.section].items[indexPath.row]
        conversationViewController.selectedName = conversation.name
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}

extension ConversationsListViewController: ThemesPickerDelegate {
    func themePicked(_ theme: Theme) {
        applyTheme(theme)
    }
}

extension ConversationsListViewController: ThemeableView {
    func applyTheme(_ theme: Theme) {
        ThemeManager.shared.currentTheme = theme
        currentTheme = theme
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
        view.backgroundColor = theme.colors.backgroundColor
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = theme.colors.navigationBarColor
        navigationBar?.titleTextAttributes = [.foregroundColor: theme.colors.primaryTextColor]
        navigationItem.leftBarButtonItem?.customView?.tintColor = theme.colors.settingsIconColor
        tableView.backgroundColor = theme.colors.backgroundColor
        tableView.backgroundView?.backgroundColor = theme.colors.backgroundColor
        tableView.reloadData()
    }
}

private struct ConversationsSection {
    let title: String
    let items: [ConversationCellModel]
}

private let conversations: [ConversationsSection] = [
    ConversationsSection(
        title: "Online",
        items: [
            ConversationCellModel(
                name: "Ronald Robertson",
                message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
                date: Date(),
                isOnline: true,
                hasUnreadMessages: true
            ),
            ConversationCellModel(
                name: "Alex Petrov",
                message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                date: Date(timeIntervalSinceNow: -3000),
                isOnline: true,
                hasUnreadMessages: true
            ),
            ConversationCellModel(
                name: "Johnny Watson",
                message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis. Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
                date: Date(timeIntervalSinceNow: -86400),
                isOnline: true,
                hasUnreadMessages: true
            ),
            ConversationCellModel(
                name: "Martha Craig",
                message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
                date: "2020/07/26 22:31".date,
                isOnline: true,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Vera Lenina",
                message: "Hi",
                date: "2020/07/20 21:22".date,
                isOnline: true,
                hasUnreadMessages: true
            ),
            ConversationCellModel(
                name: "Petr Lenin",
                message: "",
                date: "2020/07/18 20:42".date,
                isOnline: true,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Sasha Petrova",
                message: "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                date: "2020/07/11 19:02".date,
                isOnline: true,
                hasUnreadMessages: true
            ),
            ConversationCellModel(
                name: "Ekaterina Alexandrovna Konstantinova",
                message: "Where are you?",
                date: "2020/07/10 19:02".date,
                isOnline: true,
                hasUnreadMessages: true
            ),
            ConversationCellModel(
                name: "Mark Cook",
                message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
                date: "2020/07/06 00:31".date,
                isOnline: true,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Tim Cook",
                message: "",
                date: "2020/06/06 08:12".date,
                isOnline: true,
                hasUnreadMessages: false
            )
        ]
    ),
    ConversationsSection(
        title: "History",
        items: [
            ConversationCellModel(
                name: "Arthur Bell",
                message: "Voluptate irure aliquip consectetur commodo ex ex.",
                date: "2020/05/18 22:31".date,
                isOnline: false,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Jane Warren",
                message: "Ex Lorem veniam veniam irure sunt adipisicing culpa. Ex Lorem veniam veniam irure sunt adipisicing culpa. Ex Lorem veniam veniam irure sunt adipisicing culpa.",
                date: "2020/05/17 21:23".date,
                isOnline: false,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Morris Henry",
                message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                date: "2020/05/17 12:32".date,
                isOnline: false,
                hasUnreadMessages: true
            ),
            ConversationCellModel(
                name: "Irma Flores",
                message: "Amet enim do laborum tempor nisi aliqua ad adipisicing.",
                date: "2020/03/16 21:31".date,
                isOnline: false,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Colin Williams",
                message: "Ex Lorem veniam veniam irure sunt adipisicing culpa.",
                date: "2020/03/09 11:41".date,
                isOnline: false,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Anthonie Bellkins",
                message: "Voluptate irure aliquip consectetur commodo ex ex.",
                date: "2020/02/18 22:31".date,
                isOnline: false,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Lord Voldemort",
                message: "Where is the last horcrux?",
                date: "2020/02/07 21:23".date,
                isOnline: false,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Melissa Henry",
                message: "Dolore veniam Lorem occaecat veniam irure laborum est amet. Dolore veniam Lorem occaecat veniam irure laborum est amet. Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                date: "2020/02/05 12:32".date,
                isOnline: false,
                hasUnreadMessages: true
            ),
            ConversationCellModel(
                name: "Ira Flores",
                message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                date: "2020/01/01 21:31".date,
                isOnline: false,
                hasUnreadMessages: false
            ),
            ConversationCellModel(
                name: "Gerard Arthur Way",
                message: "Verni mne moj dve tyschi sedmoj",
                date: "2007/10/09 11:41".date,
                isOnline: false,
                hasUnreadMessages: true
            )
        ]
    )
]

private extension String {
    var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: self) ?? Date()
    }
}

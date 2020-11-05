//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 28.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import CoreData
import UIKit

final class ConversationsListViewController: UIViewController {
    private let repository = ChannelsRepository()
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
        repository.delegate = self
        view.addSubview(tableView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeSettingsButton())
        let profileButton = UIBarButtonItem(customView: makeProfileButton())
        let newChannelButton = UIBarButtonItem(customView: makeNewChannelButton())
        navigationItem.rightBarButtonItems = [profileButton, newChannelButton]
        applyTheme(currentTheme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repository.addChannelsListener()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        repository.removeChannelsListener()
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
    
    private func makeNewChannelButton() -> UIButton {
        let newChannelButton = UIButton(type: .custom)
        let image = UIImage(named: "NewChannelIcon")
        newChannelButton.setImage(image, for: .normal)
        newChannelButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        newChannelButton.addTarget(self, action: #selector(openNewChannelAlert), for: .touchUpInside)
        return newChannelButton
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
    
    @objc private func openNewChannelAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Enter channel name",
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        let submitAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let channelName = alertController.textFields?[0].text, !channelName.isEmpty else {
                return
            }
            self?.createNewChannel(name: channelName)
        }

        alertController.addAction(submitAction)
        present(alertController, animated: true)
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
    
    private func createNewChannel(name: String) {
        repository.addNewChannel(name: name, completion: { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                log("Add new channel error: \(error)")
            }
        })
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repository.numberOfChannels(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationsTableViewCell else {
            return UITableViewCell()
        }
        cell.applyTheme(currentTheme)
        cell.configure(with: repository.findChannel(at: indexPath))
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
        let channel = repository.findChannel(at: indexPath)
        conversationViewController.channel = channel
        navigationController?.pushViewController(conversationViewController, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        switch editingStyle {
        case .delete:
            repository.removeChannel(
                channel: repository.findChannel(at: indexPath),
                completion: { result in
                    switch result {
                    case .success:
                        break
                    case let .failure(error):
                        log("Add new channel error: \(error)")
                    }
                }
            )
        case .insert, .none:
            break
        @unknown default:
            break
        }
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

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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

private extension String {
    var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: self) ?? Date()
    }
}

//
//  ThemesViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 05.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

final class ThemesViewController: UIViewController {
    @IBOutlet weak var classicThemeButton: ThemeButton!
    @IBOutlet weak var dayThemeButton: ThemeButton!
    @IBOutlet weak var darkThemeButton: ThemeButton!
    
    var model: ThemeModelProtocol!
    
    /*
     Ставим weak, чтобы избежать retain cycle для случая, когда сохранили ссылку на ThemesViewController
     */
    weak var delegate: ThemesPickerDelegate?
    /*
     Чтобы избежать аналогичного retain cycle, захватываем self по слабой ссылке в замыкании
    */
    var onThemePicked: ((Theme) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        classicThemeButton.configure(with: buttonModels[0])
        dayThemeButton.configure(with: buttonModels[1])
        darkThemeButton.configure(with: buttonModels[2])
        applyTheme(model.currentTheme)
        switch model.currentTheme {
        case .classic:
            classicThemeButton.setSelected(true)
        case .day:
            dayThemeButton.setSelected(true)
        case .dark:
            darkThemeButton.setSelected(true)
        }
    }
    
    @IBAction func onClassicThemeButtonTap(_ sender: Any) {
        classicThemeButton.setSelected(true)
        dayThemeButton.setSelected(false)
        darkThemeButton.setSelected(false)
        pickTheme(.classic)
    }
    
    @IBAction func onDayThemeButtonTap(_ sender: Any) {
        classicThemeButton.setSelected(false)
        dayThemeButton.setSelected(true)
        darkThemeButton.setSelected(false)
        pickTheme(.day)
    }
    
    @IBAction func onDarkThemeButtonTap(_ sender: Any) {
        classicThemeButton.setSelected(false)
        dayThemeButton.setSelected(false)
        darkThemeButton.setSelected(true)
        pickTheme(.dark)
    }
    
    private func pickTheme(_ theme: Theme) {
        applyTheme(theme)
        delegate?.themePicked(theme)
        onThemePicked?(theme)
    }
}

extension ThemesViewController: ThemeableView {
    func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.colors.settingsBackgroundColor
    }
}

private let buttonModels: [ThemeButtonModel] = [
    ThemeButtonModel(
        title: "Classic",
        backgroundColor: .white,
        incomingMessageColor: UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1),
        outgoingMessageColor: UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
    ),
    ThemeButtonModel(
        title: "Day",
        backgroundColor: .white,
        incomingMessageColor: UIColor(red: 0.918, green: 0.922, blue: 0.929, alpha: 1),
        outgoingMessageColor: UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
    ),
    ThemeButtonModel(
        title: "Dark",
        backgroundColor: UIColor(red: 0.024, green: 0.024, blue: 0.024, alpha: 1),
        incomingMessageColor: UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1),
        outgoingMessageColor: UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
    )
]

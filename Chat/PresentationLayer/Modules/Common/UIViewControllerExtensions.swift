//
//  UIViewControllerExtensions.swift
//  Chat
//
//  Created by Anastasia Shmakova on 29.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

extension UIViewController {
    static func storyboardInstance() -> UIViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
}

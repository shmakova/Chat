//
//  ViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        logViewControllerState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logViewControllerState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logViewControllerState()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logViewControllerState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logViewControllerState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logViewControllerState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logViewControllerState()
    }
}

private func logViewControllerState(function: String = #function) {
    log(function)
}

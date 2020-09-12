//
//  AppDelegate.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        logApplicationState(fromState: "Not running", toState: "Inactive")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logApplicationState(fromState: "Inactive", toState: "Active")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        logApplicationState(fromState: "Active", toState: "Inactive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        logApplicationState(fromState: "Inactive", toState: "Background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logApplicationState(fromState: "Background", toState: "Inactive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        logApplicationState(fromState: "Background", toState: "Suspended")
    }
}

private func logApplicationState(fromState: String, toState: String, function: String = #function) {
    log("Application moved from \(fromState) to \(toState): \(function)")
}

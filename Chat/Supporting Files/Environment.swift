//
//  Environment.swift
//  Chat
//
//  Created by Anastasia Shmakova on 09.12.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

public enum Environment {
  enum Keys {
    enum Plist {
      static let pixabayApiHost = "PIXABAY_API_HOST"
      static let pixabayApiKey = "PIXABAY_API_KEY"
    }
  }

  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Info.plist file not found")
    }
    return dict
  }()

  static let pixabayApiHost: String = {
    guard let host = Environment.infoDictionary[Keys.Plist.pixabayApiHost] as? String else {
      fatalError("PIXABAY_API_HOST not set in plist for this environment")
    }
    return host
  }()

  static let pixabayApiKey: String = {
    guard let apiKey = Environment.infoDictionary[Keys.Plist.pixabayApiKey] as? String else {
      fatalError("PIXABAY_API_KEY not set in plist for this environment")
    }
    return apiKey
  }()
}

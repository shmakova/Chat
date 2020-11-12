//
//  FileStorageProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

protocol FileStorageProtocol {
    func saveString(key: String, oldValue: String?, newValue: String?) throws
    func loadString(key: String) throws -> String?
    func saveImage(key: String, oldValue: UIImage?, newValue: UIImage?) throws
    func loadImage(key: String) throws -> UIImage?
}

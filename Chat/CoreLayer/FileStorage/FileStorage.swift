//
//  FileStorage.swift
//  Chat
//
//  Created by Anastasia Shmakova on 14.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class FileStorage: FileStorageProtocol {
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func loadString(key: String) throws -> String? {
        let filePath = fileManager.filePath(name: key)
        guard fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        return try String(contentsOf: filePath)
    }
    
    func loadImage(key: String) throws -> UIImage? {
        let filePath = fileManager.filePath(name: key)
        guard fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        let data = try Data(contentsOf: filePath)
        return UIImage(data: data)
    }
    
    func saveString(key: String, oldValue: String?, newValue: String?) throws {
        guard oldValue != newValue else {
            return
        }
        let filePath = fileManager.filePath(name: key)
        guard let newValue = newValue, !newValue.isEmpty, let data = newValue.data(using: .utf8) else {
            if fileManager.fileExists(atPath: filePath.path) {
                try fileManager.removeItem(at: filePath)
            }
            return
        }
        try fileManager.saveFile(data: data, url: filePath)
    }
    
    func saveImage(key: String, oldValue: UIImage?, newValue: UIImage?) throws {
        guard oldValue != newValue else {
            return
        }
        let filePath = fileManager.filePath(name: key)
        guard let newValue = newValue, let data = newValue.jpegData(compressionQuality: 1.0) else {
            if fileManager.fileExists(atPath: filePath.path) {
                try fileManager.removeItem(at: filePath)
            }
            return
        }
        try fileManager.saveFile(data: data, url: filePath)
    }
}

extension FileManager {
    var documentsDirectory: URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func filePath(name: String) -> URL {
         return documentsDirectory.appendingPathComponent("\(name).txt")
    }
    
    func saveFile(data: Data, url: URL) throws {
        try data.write(to: url, options: .atomic)
    }
}

//
//  FileProfileDataManager.swift
//  Chat
//
//  Created by Anastasia Shmakova on 14.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class FileProfileDataManager: ProfileDataManaging {
    private let fileManager = FileManager.default
    
    func load(completion: @escaping (Result<ProfileData, Error>) -> Void) {
        do {
            let name = try loadString(filePath: fileManager.nameFilePath)
            let info = try loadString(filePath: fileManager.infoFilePath)
            let avatar = try loadImage(filePath: fileManager.avatarFilePath)
            completion(.success(ProfileData(name: name ?? "", info: info ?? "", avatar: avatar)))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(
        oldProfileData: ProfileData,
        newProfileData: ProfileData,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            try saveString(
                oldValue: oldProfileData.name,
                newValue: newProfileData.name,
                filePath: fileManager.nameFilePath
            )
            try saveString(
                oldValue: oldProfileData.info,
                newValue: newProfileData.info,
                filePath: fileManager.infoFilePath
            )
            try saveImage(
                oldValue: oldProfileData.avatar,
                newValue: newProfileData.avatar,
                filePath: fileManager.avatarFilePath
            )
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func loadString(filePath: URL) throws -> String? {
        guard fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        return try String(contentsOf: filePath)
    }
    
    private func loadImage(filePath: URL) throws -> UIImage? {
        guard fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        let data = try Data(contentsOf: filePath)
        return UIImage(data: data)
    }
    
    private func saveString(oldValue: String?, newValue: String?, filePath: URL) throws {
        guard oldValue != newValue else {
            return
        }
        guard let newValue = newValue, !newValue.isEmpty, let data = newValue.data(using: .utf8) else {
            if fileManager.fileExists(atPath: filePath.path) {
                try fileManager.removeItem(at: filePath)
            }
            return
        }
        try fileManager.saveFile(data: data, url: filePath)
    }
    
    private func saveImage(oldValue: UIImage?, newValue: UIImage?, filePath: URL) throws {
        guard oldValue != newValue else {
            return
        }
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
    
    var nameFilePath: URL {
        return documentsDirectory.appendingPathComponent("name.txt")
    }
    
    var infoFilePath: URL {
        return documentsDirectory.appendingPathComponent("info.txt")
    }
    
    var avatarFilePath: URL {
        return documentsDirectory.appendingPathComponent("avatar.txt")
    }
    
    func saveFile(data: Data, url: URL) throws {
        try data.write(to: url, options: .atomic)
    }
}

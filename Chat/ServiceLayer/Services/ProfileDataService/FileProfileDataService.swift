//
//  FileProfileDataService.swift
//  Chat
//
//  Created by Anastasia Shmakova on 14.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class FileProfileDataService: ProfileDataServiceProtocol {
    private let fileStorage: FileStorageProtocol
    
    init(fileStorage: FileStorageProtocol) {
        self.fileStorage = fileStorage
    }
    
    func load(completion: @escaping (Result<ProfileData, Error>) -> Void) {
        do {
            let name = try fileStorage.loadString(key: nameKey)
            let info = try fileStorage.loadString(key: infoKey)
            let avatar = try fileStorage.loadImage(key: avatarKey)
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
            try fileStorage.saveString(
                key: nameKey,
                oldValue: oldProfileData.name,
                newValue: newProfileData.name
            )
            try fileStorage.saveString(
                key: infoKey,
                oldValue: oldProfileData.info,
                newValue: newProfileData.info
            )
            try fileStorage.saveImage(
                key: avatarKey,
                oldValue: oldProfileData.avatar,
                newValue: newProfileData.avatar
            )
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

private let nameKey = "name"
private let infoKey = "info"
private let avatarKey = "avatar"

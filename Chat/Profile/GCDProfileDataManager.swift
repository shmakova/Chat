//
//  GCDProfileDataManager.swift
//  Chat
//
//  Created by Anastasia Shmakova on 13.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class GCDProfileDataManager: ProfileDataManaging {
    private let queue = DispatchQueue(label: "GCDProfileDataManager", qos: .userInitiated)
    private let mainQueue = DispatchQueue.main
    private let fileProfileDataManager: FileProfileDataManager
    
    init(fileProfileDataManager: FileProfileDataManager) {
        self.fileProfileDataManager = fileProfileDataManager
    }
    
    func load(completion: @escaping (Result<ProfileData, Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileProfileDataManager.load { result in
                self?.mainQueue.async {
                    completion(result)
                }
            }
        }
    }
    
    func save(
        oldProfileData: ProfileData,
        newProfileData: ProfileData,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        queue.async { [weak self] in
            self?.fileProfileDataManager.save(
                oldProfileData: oldProfileData,
                newProfileData: newProfileData,
                completion: { result in
                    self?.mainQueue.async {
                        completion(result)
                    }
                }
            )
        }
    }
}

//
//  GCDProfileDataService.swift
//  Chat
//
//  Created by Anastasia Shmakova on 13.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class GCDProfileDataService: ProfileDataServiceProtocol {
    private let queue = DispatchQueue(label: "GCDProfileDataManager", qos: .userInitiated)
    private let mainQueue = DispatchQueue.main
    private let fileProfileDataService: ProfileDataServiceProtocol
    
    init(fileProfileDataService: ProfileDataServiceProtocol) {
        self.fileProfileDataService = fileProfileDataService
    }
    
    func load(completion: @escaping (Result<ProfileData, Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileProfileDataService.load { result in
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
            self?.fileProfileDataService.save(
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

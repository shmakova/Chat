//
//  OperationProfileDataManager.swift
//  Chat
//
//  Created by Anastasia Shmakova on 14.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class OperationProfileDataManager: ProfileDataManaging {
    private let operationQueue = OperationQueue()
    private let mainQueue = OperationQueue.main
    private let fileProfileDataManager: FileProfileDataManager
    
    init(fileProfileDataManager: FileProfileDataManager) {
        self.fileProfileDataManager = fileProfileDataManager
        operationQueue.name = "ProfileOperationQueue"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
    }
    
    func load(completion: @escaping (Result<ProfileData, Error>) -> Void) {
        let loadOperation = LoadProfileDataOperation(
            fileProfileDataManager: fileProfileDataManager,
            completion: completion
        )
        operationQueue.addOperation(loadOperation)
    }
    
    func save(
        oldProfileData: ProfileData,
        newProfileData: ProfileData,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let saveOperation = SaveProfileDataOperation(
            fileProfileDataManager: fileProfileDataManager,
            oldProfileData: oldProfileData,
            newProfileData: newProfileData,
            completion: completion
        )
        operationQueue.addOperation(saveOperation)
    }
}

private class LoadProfileDataOperation: Operation {
    private let fileProfileDataManager: FileProfileDataManager
    private let completion: (Result<ProfileData, Error>) -> Void
    private let mainQueue: OperationQueue
    
    init(
        fileProfileDataManager: FileProfileDataManager,
        completion: @escaping (Result<ProfileData, Error>) -> Void,
        mainQueue: OperationQueue = .main
    ) {
        self.fileProfileDataManager = fileProfileDataManager
        self.completion = completion
        self.mainQueue = mainQueue
        super.init()
    }
    
    override func main() {
        fileProfileDataManager.load { result in
            self.mainQueue.addOperation {
                self.completion(result)
            }
        }
    }
}

private class SaveProfileDataOperation: Operation {
    private let fileProfileDataManager: FileProfileDataManager
    private let oldProfileData: ProfileData
    private let newProfileData: ProfileData
    private let completion: (Result<Void, Error>) -> Void
    private let mainQueue: OperationQueue
    
    init(
        fileProfileDataManager: FileProfileDataManager,
        oldProfileData: ProfileData,
        newProfileData: ProfileData,
        completion: @escaping (Result<Void, Error>) -> Void,
        mainQueue: OperationQueue = .main
    ) {
        self.fileProfileDataManager = fileProfileDataManager
        self.oldProfileData = oldProfileData
        self.newProfileData = newProfileData
        self.completion = completion
        self.mainQueue = mainQueue
        super.init()
    }
    
    override func main() {
        fileProfileDataManager.save(
            oldProfileData: oldProfileData,
            newProfileData: newProfileData,
            completion: { result in
                self.mainQueue.addOperation {
                    self.completion(result)
                }
            }
        )
    }
}

//
//  OperationProfileDataService.swift
//  Chat
//
//  Created by Anastasia Shmakova on 14.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class OperationProfileDataService: ProfileDataServiceProtocol {
    private let operationQueue = OperationQueue()
    private let mainQueue = OperationQueue.main
    private let fileProfileDataService: ProfileDataServiceProtocol
    
    init(fileProfileDataService: ProfileDataServiceProtocol) {
        self.fileProfileDataService = fileProfileDataService
        operationQueue.name = "ProfileOperationQueue"
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
    }
    
    func load(completion: @escaping (Result<ProfileData, Error>) -> Void) {
        let loadOperation = LoadProfileDataOperation(
            fileProfileDataService: fileProfileDataService,
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
            fileProfileDataService: fileProfileDataService,
            oldProfileData: oldProfileData,
            newProfileData: newProfileData,
            completion: completion
        )
        operationQueue.addOperation(saveOperation)
    }
}

private class LoadProfileDataOperation: Operation {
    private let fileProfileDataService: ProfileDataServiceProtocol
    private let completion: (Result<ProfileData, Error>) -> Void
    private let mainQueue: OperationQueue
    
    init(
        fileProfileDataService: ProfileDataServiceProtocol,
        completion: @escaping (Result<ProfileData, Error>) -> Void,
        mainQueue: OperationQueue = .main
    ) {
        self.fileProfileDataService = fileProfileDataService
        self.completion = completion
        self.mainQueue = mainQueue
        super.init()
    }
    
    override func main() {
        fileProfileDataService.load { result in
            self.mainQueue.addOperation {
                self.completion(result)
            }
        }
    }
}

private class SaveProfileDataOperation: Operation {
    private let fileProfileDataService: ProfileDataServiceProtocol
    private let oldProfileData: ProfileData
    private let newProfileData: ProfileData
    private let completion: (Result<Void, Error>) -> Void
    private let mainQueue: OperationQueue
    
    init(
        fileProfileDataService: ProfileDataServiceProtocol,
        oldProfileData: ProfileData,
        newProfileData: ProfileData,
        completion: @escaping (Result<Void, Error>) -> Void,
        mainQueue: OperationQueue = .main
    ) {
        self.fileProfileDataService = fileProfileDataService
        self.oldProfileData = oldProfileData
        self.newProfileData = newProfileData
        self.completion = completion
        self.mainQueue = mainQueue
        super.init()
    }
    
    override func main() {
        fileProfileDataService.save(
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

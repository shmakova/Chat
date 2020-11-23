//
//  ProfileModel.swift
//  Chat
//
//  Created by Anastasia Shmakova on 13.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

protocol ProfileModelProtocol {
    var delegate: ProfileViewControllerDelegate? { get set }
    var currentTheme: Theme { get }
    func loadProfile()
    func saveProfile(
        method: ProfileDataManagerMethod,
        currentProfile: ProfileData,
        unsavedProfile: ProfileData
    )
}

protocol ProfileViewControllerDelegate: class {
    func handleLoadProfileResult(_ result: Result<ProfileData, Error>)
    func handleSaveProfileResult(
        _ result: Result<Void, Error>,
        profile: ProfileData
    )
}

class ProfileModel: ProfileModelProtocol {
    private let themeService: ThemeServiceProtocol
    private let gcdProfileDataService: ProfileDataServiceProtocol
    private let operationProfileDataService: ProfileDataServiceProtocol
    
    weak var delegate: ProfileViewControllerDelegate?
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    init(
        themeService: ThemeServiceProtocol,
        gcdProfileDataService: ProfileDataServiceProtocol,
        operationProfileDataService: ProfileDataServiceProtocol
    ) {
        self.themeService = themeService
        self.gcdProfileDataService = gcdProfileDataService
        self.operationProfileDataService = operationProfileDataService
    }
    
    func loadProfile() {
        operationProfileDataService.load(completion: { [weak self] result in
            self?.delegate?.handleLoadProfileResult(result)
        })
    }
    
    func saveProfile(
        method: ProfileDataManagerMethod,
        currentProfile: ProfileData,
        unsavedProfile: ProfileData
    ) {
        let profileDataService: ProfileDataServiceProtocol
        switch method {
        case .gcd:
            profileDataService = gcdProfileDataService
        case .operation:
            profileDataService = operationProfileDataService
        }
        profileDataService.save(
            oldProfileData: currentProfile,
            newProfileData: unsavedProfile,
            completion: { [weak self] in
                self?.delegate?.handleSaveProfileResult($0, profile: unsavedProfile)
            }
        )
    }
}

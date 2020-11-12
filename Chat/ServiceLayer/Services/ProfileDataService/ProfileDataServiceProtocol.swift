//
//  ProfileDataServiceProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 13.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

protocol ProfileDataServiceProtocol: class {
    func load(completion: @escaping (Result<ProfileData, Error>) -> Void)
    func save(
        oldProfileData: ProfileData,
        newProfileData: ProfileData,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

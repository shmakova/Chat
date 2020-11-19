//
//  ImagesApiModel.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

struct ImagesApiModel: Codable {
    let hits: [Hit]
    
    struct Hit: Codable {
        let webformatURL: String
    }
}

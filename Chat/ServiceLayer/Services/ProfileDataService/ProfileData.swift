//
//  ProfileData.swift
//  Chat
//
//  Created by Anastasia Shmakova on 13.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

struct ProfileData: Equatable {
    static let empty = ProfileData(
        name: "",
        info: "",
        avatar: nil
    )
    
    var name: String
    var info: String
    var avatar: UIImage?
    
    var initials: String? {
        formatter.style = .abbreviated
        guard let components = formatter.personNameComponents(from: name) else {
            return nil
        }
        return formatter.string(from: components)
    }
}

private let formatter = PersonNameComponentsFormatter()

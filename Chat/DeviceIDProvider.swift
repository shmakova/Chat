//
//  DeviceIDProvider.swift
//  Chat
//
//  Created by Anastasia Shmakova on 21.10.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

final class DeviceIDProvider {
    var deviceID: String {
        guard let id = UIDevice.current.identifierForVendor?.uuidString else {
            return ""
        }
        return id
    }
}

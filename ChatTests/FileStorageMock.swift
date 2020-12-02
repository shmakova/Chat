//
//  FileStorageMock.swift
//  ChatTests
//
//  Created by Anastasia Shmakova on 02.12.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

@testable import Chat
import UIKit

class FileStorageMock: FileStorageProtocol {
    var saveStringCallsCount = 0
    var loadStringCallsCount = 0
    var saveImageCallsCount = 0
    var loadImageCallsCount = 0
    var receivedOldValueStrings: [String?] = []
    var receivedNewValueStrings: [String?] = []
    var receivedOldValueImages: [UIImage?] = []
    var receivedNewValueImages: [UIImage?] = []
    var receivedKeys: [String] = []
    var loadStringStub: String?
    var loadImageStub: UIImage?
    
    func saveString(key: String, oldValue: String?, newValue: String?) throws {
        saveStringCallsCount += 1
        receivedKeys.append(key)
        receivedOldValueStrings.append(oldValue)
        receivedNewValueStrings.append(newValue)
    }
    
    func loadString(key: String) throws -> String? {
        loadStringCallsCount += 1
        receivedKeys.append(key)
        return loadStringStub
    }
    
    func saveImage(key: String, oldValue: UIImage?, newValue: UIImage?) throws {
        saveImageCallsCount += 1
        receivedKeys.append(key)
        receivedOldValueImages.append(oldValue)
        receivedNewValueImages.append(newValue)
    }
    
    func loadImage(key: String) throws -> UIImage? {
        loadImageCallsCount += 1
        receivedKeys.append(key)
        return loadImageStub
    }
}

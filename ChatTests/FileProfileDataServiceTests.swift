//
//  FileProfileDataServiceTests.swift
//  ChatTests
//
//  Created by Anastasia Shmakova on 01.12.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

@testable import Chat
import XCTest
import UIKit

class FileProfileDataServiceTests: XCTestCase {
    private let fileStorage = FileStorageMock()
    
    private lazy var service = FileProfileDataService(fileStorage: fileStorage)
    
    func testWhenLoadProfile_ShouldCallLoadStringTwice() {
        service.load(completion: { _ in })
        XCTAssertEqual(fileStorage.loadStringCallsCount, 2)
    }
    
    func testWhenLoadProfile_ShouldCallLoadImageOnce() {
        service.load(completion: { _ in })
        XCTAssertEqual(fileStorage.loadImageCallsCount, 1)
    }
    
    func testWhenLoadProfile_ShouldCallLoadForAllKeys() {
        service.load(completion: { _ in })
        XCTAssertEqual(fileStorage.receivedKeys, ["name", "info", "avatar"])
    }
    
    func testWhenLoadProfileWithoutExceptions_ShouldCallSuccessCompletion() {
        var result: Result<ProfileData, Error>?
        fileStorage.loadImageStub = UIImage(named: "image")
        fileStorage.loadStringStub = "string"
        service.load(completion: { result = $0 })
        switch result {
        case let .success(profile):
            XCTAssertEqual(
                profile,
                ProfileData(
                    name: "string",
                    info: "string",
                    avatar: UIImage(named: "image")
                )
            )
        case .failure, .none:
            XCTFail("Result should not be failure or none")
        }
    }

    func testWhenSaveProfile_ShouldCallSaveStringTwice() {
        service.save(
            oldProfileData: .empty,
            newProfileData: profileData,
            completion: { _ in }
        )
        XCTAssertEqual(fileStorage.saveStringCallsCount, 2)
    }
    
    func testWhenSaveProfile_ShouldCallSaveImageOnce() {
        service.save(
            oldProfileData: .empty,
            newProfileData: profileData,
            completion: { _ in }
        )
        XCTAssertEqual(fileStorage.saveImageCallsCount, 1)
    }
    
    func testWhenSaveProfile_ShouldReceiveAllKeys() {
        service.save(
            oldProfileData: .empty,
            newProfileData: profileData,
            completion: { _ in }
        )
        XCTAssertEqual(fileStorage.receivedKeys, ["name", "info", "avatar"])
    }
    
    func testWhenSaveProfile_ShouldReceiveAllOldValueStrings() {
        service.save(
            oldProfileData: .empty,
            newProfileData: profileData,
            completion: { _ in }
        )
        XCTAssertEqual(fileStorage.receivedOldValueStrings, ["", ""])
    }
    
    func testWhenSaveProfile_ShouldReceiveAllNewValueStrings() {
        service.save(
            oldProfileData: .empty,
            newProfileData: profileData,
            completion: { _ in }
        )
        XCTAssertEqual(fileStorage.receivedNewValueStrings, ["Ivan", "Engineer"])
    }
    
    func testWhenSaveProfile_ShouldReceiveAllOldValueImages() {
        service.save(
            oldProfileData: .empty,
            newProfileData: profileData,
            completion: { _ in }
        )
        XCTAssertEqual(fileStorage.receivedOldValueImages, [nil])
    }
    
    func testWhenSaveProfile_ShouldReceiveAllNewValueImages() {
        service.save(
            oldProfileData: .empty,
            newProfileData: profileData,
            completion: { _ in }
        )
        XCTAssertEqual(fileStorage.receivedNewValueImages, [UIImage(named: "image")])
    }
    
    func testWhenSaveProfileWithoutExceptions_ShouldCallSuccessCompletion() {
        var result: Result<Void, Error>?
        service.save(
            oldProfileData: .empty,
            newProfileData: profileData,
            completion: { result = $0 }
        )
        switch result {
        case .success:
            XCTAssert(true)
        case .failure, .none:
            XCTFail("Result should not be failure or none")
        }
    }
}

private let profileData = ProfileData(
    name: "Ivan",
    info: "Engineer",
    avatar: UIImage(named: "image")
)

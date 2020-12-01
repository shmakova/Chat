//
//  ImagesServiceProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

protocol ImagesServiceProtocol: class {
    func loadImages(completion: @escaping (Result<[ImageCellModel], Error>) -> Void)
    func loadImage(model: ImageCellModel, completion: @escaping (Result<UIImage, Error>) -> Void)
    func clearCache()
}

//
//  ImageLoader.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ImageLoader: ImageLoaderProtocol {
    
    private let operationQueue: OperationQueue
    private let mainQueue: OperationQueue
    
    init(
        operationQueue: OperationQueue,
        mainQueue: OperationQueue
    ) {
        self.operationQueue = operationQueue
        self.mainQueue = mainQueue
    }
    
    func loadImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        operationQueue.addOperation {
            let result = url.loadImage()
            self.mainQueue.addOperation {
                completion(result)
            }
        }
    }
}

private extension URL {
    func loadImage() -> Result<UIImage, Error> {
        assert(!Thread.isMainThread)
        do {
            let data = try Data(contentsOf: self)
            guard let image = UIImage(data: data) else {
                return .failure(ImageLoaderError.invalidImage)
            }
            return .success(image)
        } catch {
            return .failure(error)
        }
    }
}

private enum ImageLoaderError: Error {
    case invalidImage
}

//
//  ImagesService.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ImagesService: ImagesServiceProtocol {
    
    private let requestSender: RequestSenderProtocol
    private let imagesRequestConfig: RequestConfig<ImagesParser>
    private let imageLoader: ImageLoaderProtocol
    private let mainQueue: OperationQueue
    
    private var imageStorage: [UUID: UIImage?] = [:]
    
    init(
        requestSender: RequestSenderProtocol,
        imagesRequestConfig: RequestConfig<ImagesParser>,
        imageLoader: ImageLoaderProtocol,
        mainQueue: OperationQueue = .main
    ) {
        self.requestSender = requestSender
        self.imagesRequestConfig = imagesRequestConfig
        self.imageLoader = imageLoader
        self.mainQueue = mainQueue
    }
    
    func loadImages(completion: @escaping (Result<[ImageCellModel], Error>) -> Void) {
        requestSender.send(
            requestConfig: imagesRequestConfig,
            completion: { result in
                self.mainQueue.addOperation {
                    switch result {
                    case let .success(apiModel):
                        let imageCellModels = apiModel.hits
                            .compactMap { URL(string: $0.webformatURL) }
                            .map { ImageCellModel(identifier: UUID(), url: $0) }
                        completion(.success(imageCellModels))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        )
    }
    
    func loadImage(model: ImageCellModel, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = imageStorage[model.identifier], let image = cachedImage {
            completion(.success(image))
            return
        }
        imageLoader.loadImage(
            url: model.url,
            completion: { [weak self] in
                switch $0 {
                case let .success(image):
                    self?.imageStorage[model.identifier] = image
                case .failure:
                    break
                }
                completion($0)
            }
        )
    }
    
    func clearCache() {
        imageStorage.removeAll()
    }
}

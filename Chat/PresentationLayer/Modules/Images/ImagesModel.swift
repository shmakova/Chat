//
//  ImagesModel.swift
//  Chat
//
//  Created by Anastasia Shmakova on 18.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

protocol ImagesModelProtocol {
    var delegate: ImagesViewControllerDelegate? { get set }
    var currentTheme: Theme { get }
    func loadImages()
    func loadImage(model: ImageCellModel, completion: @escaping (Result<UIImage, Error>) -> Void)
    func clearCache()
}

protocol ImagesViewControllerDelegate: class {
    func handleLoadImagesResult(_ result: Result<[ImageCellModel], Error>)
}

class ImagesModel: ImagesModelProtocol {
    private let themeService: ThemeServiceProtocol
    private let imagesService: ImagesServiceProtocol
    
    weak var delegate: ImagesViewControllerDelegate?
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    init(
        themeService: ThemeServiceProtocol,
        imagesService: ImagesServiceProtocol
    ) {
        self.themeService = themeService
        self.imagesService = imagesService
    }
    
    func loadImages() {
        imagesService.loadImages(completion: { [weak self] in
            self?.delegate?.handleLoadImagesResult($0)
        })
    }
    
    func loadImage(model: ImageCellModel, completion: @escaping (Result<UIImage, Error>) -> Void) {
        imagesService.loadImage(model: model, completion: completion)
    }
    
    func clearCache() {
        imagesService.clearCache()
    }
}

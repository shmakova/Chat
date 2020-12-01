//
//  ImageLoaderProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

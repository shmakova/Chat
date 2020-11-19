//
//  ImagesRequest.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

// https://pixabay.com/api/?key={ KEY }&q=yellow+flowers&image_type=photo

class ImagesRequest: RequestProtocol {
    private let apiKey: String

    private var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pixabay.com"
        components.path = "/api"
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: "avatar"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "per_page", value: "200")
        ]
        return components.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

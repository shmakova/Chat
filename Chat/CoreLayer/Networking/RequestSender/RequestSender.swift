//
//  RequestSender.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class RequestSender: RequestSenderProtocol {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func send<Parser>(
        requestConfig config: RequestConfig<Parser>,
        completion: @escaping (Result<Parser.Model, Error>) -> Void
    ) {
        guard let urlRequest = config.request.urlRequest else {
            completion(.failure(RequestSenderError.invalidURLRequest))
            return
        }
        
        let task = session.dataTask(
            with: urlRequest,
            completionHandler: { (data: Data?, _, error: Error?) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data,
                    let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                        completion(.failure(RequestSenderError.invalidData))
                        return
                }
                completion(.success(parsedModel))
            }
        )
        task.resume()
    }
}

private enum RequestSenderError: Error {
    case invalidURLRequest
    case invalidData
}

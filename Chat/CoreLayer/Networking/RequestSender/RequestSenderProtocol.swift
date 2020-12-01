//
//  RequestSenderProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}

protocol RequestSenderProtocol {
    func send<Parser>(
        requestConfig: RequestConfig<Parser>,
        completion: @escaping (Result<Parser.Model, Error>) -> Void
    )
}

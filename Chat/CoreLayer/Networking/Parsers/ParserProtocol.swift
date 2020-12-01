//
//  ParserProtocol.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    associatedtype Model
    
    func parse(data: Data) -> Model?
}

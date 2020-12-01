//
//  ImagesParser.swift
//  Chat
//
//  Created by Anastasia Shmakova on 19.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class ImagesParser: ParserProtocol {
    func parse(data: Data) -> ImagesApiModel? {
        let decoder = JSONDecoder()
        guard let imagesApiModel = try? decoder.decode(ImagesApiModel.self, from: data) else {
            return nil
        }
        return imagesApiModel
    }
}

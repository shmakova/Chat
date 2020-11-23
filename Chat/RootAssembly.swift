//
//  RootAssembly.swift
//  Chat
//
//  Created by Anastasia Shmakova on 11.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly = PresentationAssembly(servicesAssembly: servicesAssembly)
    private lazy var servicesAssembly = ServicesAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly = CoreAssembly()
}

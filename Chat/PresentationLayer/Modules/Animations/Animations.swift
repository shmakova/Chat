//
//  Animations.swift
//  Chat
//
//  Created by Anastasia Shmakova on 24.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

extension CAAnimation {
    static var buttonAnimation: CAAnimation {
        let translationXAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translationXAnimation.values = [-5, 0, 5, 0, -5]
        translationXAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        
        let translationYAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        translationYAnimation.values = [-5, 0, 5, 0, -5]
        translationYAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        
        let angle = Double.pi / 10
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.values = [0, angle, 0, -angle, 0]
        rotationAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.3
        groupAnimation.repeatCount = .infinity
        groupAnimation.animations = [
            rotationAnimation,
            translationXAnimation,
            translationYAnimation
        ]
        return groupAnimation
    }
}

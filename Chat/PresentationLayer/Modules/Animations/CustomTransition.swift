//
//  CustomTransition.swift
//  Chat
//
//  Created by Anastasia Shmakova on 25.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to),
            let snapshot = toView.snapshotView(afterScreenUpdates: true)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        snapshot.frame = originFrame
        snapshot.layer.cornerRadius = 16
        snapshot.layer.masksToBounds = true
        containerView.addSubview(toView)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransform(for: containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1 / 3) {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
                }
                UIView.addKeyframe(withRelativeStartTime: 1 / 3, relativeDuration: 1 / 3) {
                    snapshot.layer.transform = AnimationHelper.yRotation(0.0)
                }
                UIView.addKeyframe(withRelativeStartTime: 2 / 3, relativeDuration: 1 / 3) {
                    snapshot.frame = finalFrame
                    snapshot.layer.cornerRadius = 0
                }
            },
            completion: { _ in
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}

private struct AnimationHelper {
    static func yRotation(_ angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransform(for containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
}

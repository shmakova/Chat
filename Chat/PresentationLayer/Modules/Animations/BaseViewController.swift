//
//  BaseViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 25.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private lazy var tinkoffLogoCell: CAEmitterCell = {
        var tinkoffLogoCell = CAEmitterCell()
        tinkoffLogoCell.contents = UIImage(named: "TinkoffIcon")?.cgImage
        tinkoffLogoCell.scale = 0.06
        tinkoffLogoCell.scaleRange = 0.3
        tinkoffLogoCell.emissionRange = .pi
        tinkoffLogoCell.lifetime = 1.5
        tinkoffLogoCell.birthRate = 20
        tinkoffLogoCell.velocity = -30
        tinkoffLogoCell.velocityRange = -20
        tinkoffLogoCell.spin = -0.5
        tinkoffLogoCell.spinRange = 1.0
        return tinkoffLogoCell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        gestureRecognizer.minimumPressDuration = 0
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: view)
        showTinkoffLogos(into: view, point: location)
        
        if sender.state == .began {
            showTinkoffLogos(into: view, point: location)
        }
    }
    
    private func showTinkoffLogos(into view: UIView, point: CGPoint) {
        let tinkoffLogoLayer = CAEmitterLayer()
        tinkoffLogoLayer.emitterPosition = CGPoint(x: point.x, y: point.y)
        tinkoffLogoLayer.emitterShape = CAEmitterLayerEmitterShape.line
        tinkoffLogoLayer.beginTime = CACurrentMediaTime()
        tinkoffLogoLayer.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
        tinkoffLogoLayer.emitterCells = [tinkoffLogoCell]
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            tinkoffLogoLayer.birthRate = 0
        }
        view.layer.addSublayer(tinkoffLogoLayer)
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

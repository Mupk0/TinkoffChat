//
//  EmitterAnimation.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.04.2021.
//

import UIKit

class EmitterAnimation {
    
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        
        self.window = window
    }
    
    public func startAnimation(gesture: UIGestureRecognizer) {
        emitterLayer.emitterPosition = gesture.location(in: window)
        
        switch gesture.state {
        case .began:
            window?.layer.addSublayer(emitterLayer)
        case .changed:
            stopAnimation()
            window?.layer.addSublayer(emitterLayer)
        default:
            stopAnimation()
        }
    }
    
    private func stopAnimation() {
        emitterLayer.removeAllAnimations()
        emitterLayer.removeFromSuperlayer()
    }
    
    lazy private var emitterLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterShape = .line
        layer.emitterSize = CGSize(width: 1, height: 1)
        layer.emitterCells = [emitterCell]
        
        return layer
    }()
    
    lazy private var emitterCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.birthRate = Float.random(in: 3...10)
        cell.lifetime = Float.random(in: 0.5...1)
        cell.lifetimeRange = 3.0
        cell.velocity = CGFloat.random(in: 100...150)
        cell.velocityRange = 20
        cell.spin = 1
        cell.spinRange = 2
        cell.scale = 0.02
        cell.scaleRange = 0.05
        cell.scaleSpeed = 0.05
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.contents = #imageLiteral(resourceName: "logo").cgImage
        
        return cell
    }()
}

//
//  ShakeAnimation.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.04.2021.
//

import UIKit

class ShakeAnimation {
    
    enum AnimationState {
        case started
        case stopped
    }
    
    private let layer: CALayer
    private var state: AnimationState = .stopped
    
    init(layer: CALayer) {
        self.layer = layer
    }
    
    public func setAnimationState(_ state: AnimationState) {
        switch state {
        case .started:
            startShakeAnimation()
        case .stopped:
            stopShakeAnimation()
        }
    }
    
    private func startShakeAnimation() {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let moveAnimation = CAKeyframeAnimation(keyPath: "position")
        moveAnimation.values = [
            layer.position,
            CGPoint(x: layer.position.x + 5, y: layer.position.y),
            CGPoint(x: layer.position.x, y: layer.position.y + 5),
            CGPoint(x: layer.position.x - 5, y: layer.position.y),
            CGPoint(x: layer.position.x, y: layer.position.y - 5)
        ]
        moveAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = CGFloat.pi / 18
        rotateAnimation.toValue = -CGFloat.pi / 18
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.autoreverses = true
        animationGroup.repeatCount = .infinity
        animationGroup.fillMode = .both
        animationGroup.animations = [moveAnimation, rotateAnimation]
        
        layer.add(animationGroup, forKey: nil)
    }
    
    private func stopShakeAnimation() {
        layer.removeAllAnimations()
        
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = layer.presentation()?.position
        moveAnimation.toValue = layer.position
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = layer.presentation()?.value(forKeyPath: "transform.rotation") as? CGFloat
        rotateAnimation.toValue = 0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.fillMode = .both
        animationGroup.animations = [moveAnimation, rotateAnimation]
        
        layer.add(animationGroup, forKey: nil)
        
        CATransaction.setCompletionBlock {
            self.layer.removeAllAnimations()
        }
    }
}

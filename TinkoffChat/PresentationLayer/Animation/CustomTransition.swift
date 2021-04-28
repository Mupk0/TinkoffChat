//
//  CustomTransition.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.04.2021.
//

import UIKit

class CustomTransition: NSObject {
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    private let animationDuration: Double
    private let animationType: AnimationType
    
    init(animationDuration: Double,
         animationType: AnimationType) {
        
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

extension CustomTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext,
                             view: toViewController.view,
                             size: fromViewController.view.frame)
        case .dismiss:
            dismissAnimation(with: transitionContext,
                             view: fromViewController.view,
                             size: toViewController.view.frame)
        }
    }
    
    private func presentAnimation(with context: UIViewControllerContextTransitioning,
                                  view: UIView,
                                  size: CGRect) {
        
        view.frame = CGRect(x: 0,
                            y: size.height,
                            width: size.width,
                            height: size.height)
        
        UIView.animate(withDuration: transitionDuration(using: context),
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        view.frame = CGRect(x: 0,
                                            y: 0,
                                            width: size.width,
                                            height: size.height)
                        
                       }, completion: { _ in
                        context.completeTransition(true)
                       })
    }
    
    private func dismissAnimation(with context: UIViewControllerContextTransitioning,
                                  view: UIView,
                                  size: CGRect) {
        
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration * 0.25,
                       delay: 0,
                       animations: {
                        view.frame = CGRect(x: 0,
                                            y: -size.height * 0.25,
                                            width: size.width,
                                            height: size.height)
                       }, completion: { _ in
                        UIView.animate(withDuration: duration * 0.75,
                                       delay: 0,
                                       animations: {
                                        view.frame = CGRect(x: 0,
                                                            y: size.height,
                                                            width: size.width,
                                                            height: size.height)
                                       }, completion: { _ in
                                        view.removeFromSuperview()
                                        context.completeTransition(true)
                                       })
                       })
    }
}

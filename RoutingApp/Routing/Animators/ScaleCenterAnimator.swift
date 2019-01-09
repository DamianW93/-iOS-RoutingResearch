//
//  ScaleCenterAnimator.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/12/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class ScaleCenterAnimator: NSObject, Animator {
    
    var isPresenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            present(using: transitionContext)
        }
        else {
            dismiss(using: transitionContext)
        }
    }
    
    private func present(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)
//        toViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        [toViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//         toViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//         toViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
//         toViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)].forEach { $0.isActive = true }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

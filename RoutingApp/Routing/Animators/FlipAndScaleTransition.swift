//
//  FlipAndScaleTransition.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 20/12/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class FlipAndScaleTransition: NSObject, Animator {

    private let originFrame: CGRect

    var isPresenting: Bool = true

    init(originFrame: CGRect) {
        self.originFrame = originFrame
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) as? PhotoDetailsViewController,
            var snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else {
                return
        }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        containerView.addSubview(toVC.view)
        toVC.view.translatesAutoresizingMaskIntoConstraints = false
        [toVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         toVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         toVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
         toVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)].forEach { $0.isActive = true }
        toVC.view.layoutIfNeeded()
        
        snapshot = toVC.imageView.snapshotView(afterScreenUpdates: true)!
        snapshot.frame = originFrame
        snapshot.layer.cornerRadius = 40
        snapshot.layer.masksToBounds = true

        containerView.addSubview(snapshot)

        toVC.view.alpha = 0
//        snapshot.frame = containerView.frame
//
//        snapshot.translatesAutoresizingMaskIntoConstraints = false
//        [snapshot.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            snapshot.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            snapshot.topAnchor.constraint(equalTo: containerView.topAnchor),
//            snapshot.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)].forEach { $0.isActive = true }
//        snapshot.layoutIfNeeded()
        
        AnimationHelper.perspectiveTransform(for: containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)

        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1 / 4, animations: {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
                })

                UIView.addKeyframe(withRelativeStartTime: 1 / 4, relativeDuration: 1 / 4, animations: {
                    snapshot.layer.transform = AnimationHelper.yRotation(0.0)
                })

                UIView.addKeyframe(withRelativeStartTime: 2 / 4, relativeDuration: 1 / 4, animations: {
                    snapshot.frame = finalFrame
                    snapshot.layer.cornerRadius = 0
                })
                
                UIView.addKeyframe(withRelativeStartTime: 3 / 4, relativeDuration: 1 / 4, animations: {
                    toVC.view.alpha = 1
                })
            }) { _ in
            snapshot.removeFromSuperview()
            fromVC.view.layer.transform = CATransform3DIdentity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

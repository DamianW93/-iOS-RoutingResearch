//
//  AnimationHelper.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 20/12/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

struct AnimationHelper {
    static func yRotation(_ angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransform(for containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
}

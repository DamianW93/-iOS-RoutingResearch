//
//  Animator.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/12/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}

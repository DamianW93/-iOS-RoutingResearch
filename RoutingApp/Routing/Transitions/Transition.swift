//
//  Transition.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/11/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

protocol Transition: class {
    
    var viewController: UIViewController? { get set }
    
    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController)
}

enum TransitionType {
    case push(animator: Animator?)
    case modal(animator: Animator?)
    
    var transition: Transition {
        switch self {
        case .push(let animator): return PushTransition()
        case .modal(let animator): return ModalTransition(animator: animator)
        }
    }
}

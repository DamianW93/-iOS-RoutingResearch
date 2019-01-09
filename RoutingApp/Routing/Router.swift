//
//  Router.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/11/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

protocol Closable: class {
    func close()
}

protocol RouterProtocol: class {
    
    var viewController: UIViewController? { get }
    
    var openTransition: Transition? { get set }
    
    func open(_ viewController: UIViewController, transition: Transition)
}

class Router: RouterProtocol, Closable {
    
    weak var viewController: UIViewController?
    var openTransition: Transition?
    
    func open(_ viewController: UIViewController, transition: Transition) {
        transition.viewController = self.viewController        
        transition.open(viewController)
    }
    
    func close() {
        guard let openTransition = openTransition else {
            assertionFailure("You should specify an open transition in order to close a module.")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close.")
            return
        }
        openTransition.close(viewController)
    }
}


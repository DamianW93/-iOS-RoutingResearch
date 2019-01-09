//
//  PushTransition.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/11/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class PushTransition: NSObject {
    
    let isAnimated: Bool
    
    weak var viewController: UIViewController?
    
    init(isAnimated: Bool = true) {
        self.isAnimated = isAnimated
    }
}

extension PushTransition: Transition {
    
    func open(_ viewController: UIViewController) {
        self.viewController?.navigationController?.pushViewController(viewController, animated: isAnimated)
    }
    
    func close(_ viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: isAnimated)
    }
}

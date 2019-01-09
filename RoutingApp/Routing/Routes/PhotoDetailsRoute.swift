//
//  PhotoDetailsRouter.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/11/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

protocol PhotoDetailsRoute {
    func openPhotoDetails(photo: UIImage, transitionType: TransitionType)
}

extension PhotoDetailsRoute where Self: RouterProtocol {

    func openPhotoDetails(photo: UIImage, transitionType: TransitionType = .push(animator: nil)) {
        let transition = transitionType.transition
        let controller = PhotoDetailsViewController(image: photo)
        controller.router.openTransition = transition

        open(controller, transition: transition)
    }
}

//
//  MainViewModel.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/11/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class MainViewModel {
    
    let router: MainRouter.Routes
    
    init(router: MainRouter.Routes) {
        self.router = router
    }
    
    func showPhotoDetails(withImage: UIImage, andAnimator: Animator?) {
        router.openPhotoDetails(photo: withImage, transitionType: .modal(animator: andAnimator))
    }
}

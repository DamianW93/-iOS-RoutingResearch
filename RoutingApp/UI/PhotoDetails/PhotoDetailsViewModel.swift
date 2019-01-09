//
//  PhotoDetailsViewModel.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/11/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import Foundation

class PhotoDetailsViewModel {
    
    let router: PhotoDetailsRouter.Routes
    
    init(router: PhotoDetailsRouter.Routes) {
        self.router = router
    }
    
    func closeEvent() {
        router.close()
    }
}

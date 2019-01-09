//
//  PhotoDetailsViewController.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/11/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    lazy var router: PhotoDetailsRouter.Routes = {
        let router = PhotoDetailsRouter()
        router.viewController = self
        
        return router
    }()
    
    private lazy var viewModel: PhotoDetailsViewModel = {
        return PhotoDetailsViewModel(router: router)
    }()
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        
        self.view.addSubview(imageView)
        self.view.addSubview(closeButton)
        [closeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
         closeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)].forEach { $0.isActive = true }
        
        [imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
         imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
         imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
         imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)].forEach { $0.isActive = true }
        
        imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .green
    }
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTouch), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @objc private func closeButtonDidTouch() {
        viewModel.closeEvent()
    }
}

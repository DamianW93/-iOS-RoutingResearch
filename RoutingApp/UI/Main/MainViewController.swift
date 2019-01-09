//
//  ViewController.swift
//  RoutingApp
//
//  Created by Damian Włodarczyk on 12/11/2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var router: MainRouter.Routes = {
       let router = MainRouter()
        router.viewController = self
        return router
    }()

    private lazy var viewModel: MainViewModel = {
        return MainViewModel(router: router)
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // Button
    private lazy var navigateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Navigate", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 40
        button.addTarget(self, action: #selector(navigateButtonDidTouch), for: .touchUpInside)
        return button
    }()
    
    @objc private func navigateButtonDidTouch() {
        viewModel.showPhotoDetails(withImage: #imageLiteral(resourceName: "Image"), andAnimator: FlipAndScaleTransition(originFrame: navigateButton.frame))
    }
}

extension MainViewController {
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .clear
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.view.addSubview(navigateButton)
        [navigateButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
         navigateButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
         navigateButton.widthAnchor.constraint(equalToConstant: 200),
         navigateButton.heightAnchor.constraint(equalToConstant: 400)].forEach { $0.isActive = true }
    }
}

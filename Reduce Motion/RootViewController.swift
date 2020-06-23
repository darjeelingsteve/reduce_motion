//
//  RootViewController.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 20/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The view controller responsible for hosting the main scene's user interface.
final class RootViewController: UIViewController {
    private let childNavigationController: UINavigationController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        childNavigationController = UINavigationController(rootViewController: ColourPaletteViewController(colourPalette: ColourPalette.systemColours))
        childNavigationController.navigationBar.prefersLargeTitles = true
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(childNavigationController)
        view.addSubview(childNavigationController.view)
        childNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        childNavigationController.didMove(toParent: self)
    }
}

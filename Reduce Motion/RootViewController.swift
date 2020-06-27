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
    private var colourDetailsViewTransitioningDelegate: ColourDetailsViewTransitioningDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let colourPaletteViewController = ColourPaletteViewController(colourPalette: ColourPalette.systemColours)
        childNavigationController = UINavigationController(rootViewController: colourPaletteViewController)
        childNavigationController.navigationBar.prefersLargeTitles = true
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        colourPaletteViewController.delegate = self
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

// MARK: - ColourPaletteViewControllerDelegate

extension RootViewController: ColourPaletteViewControllerDelegate {
    func colourPaletteViewController(_ colourPaletteViewController: ColourPaletteViewController, didSelectColourDetails colourDetails: ColourDetails, selectionRect: CGRect) {
        colourDetailsViewTransitioningDelegate = ColourDetailsViewTransitioningDelegate(sourceRect: selectionRect)
        let colourDetailsViewController = ColourDetailsViewController(colourDetails: colourDetails)
        colourDetailsViewController.delegate = self
        colourDetailsViewController.transitioningDelegate = colourDetailsViewTransitioningDelegate
        colourDetailsViewController.modalPresentationStyle = .custom
        present(colourDetailsViewController, animated: true)
    }
}

// MARK: - ColourDetailsViewControllerDelegate

extension RootViewController: ColourDetailsViewControllerDelegate {
    func colourDetailsViewControllerDidFinish(_ colourDetailsViewController: ColourDetailsViewController) {
        dismiss(animated: true) {
            self.colourDetailsViewTransitioningDelegate = nil
        }
    }
}

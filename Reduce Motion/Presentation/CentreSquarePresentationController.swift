//
//  CentreSquarePresentationController.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 24/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The presentation controller responsible for presenting view controllers
/// centred within the presentation context.
final class CentreSquarePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let containerBounds = containerView.bounds
        let minDimension = min(containerBounds.width, containerBounds.height)
        let padding: CGFloat = 48
        return containerView.bounds.insetBy(dx: (containerBounds.width - minDimension + padding) / 2,
                                            dy: (containerBounds.height - minDimension + padding) / 2)
    }
    
    private lazy var backgroundDimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return dimmingView
    }()
    
    override func presentationTransitionWillBegin() {
        presentedViewController.view.layer.cornerRadius = 12
        presentedViewController.view.layer.cornerCurve = .continuous
        presentedViewController.view.clipsToBounds = true
        
        if let containerView = containerView {
            backgroundDimmingView.frame = containerView.bounds
            containerView.addSubview(backgroundDimmingView)
            backgroundDimmingView.alpha = 0.0
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundDimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundDimmingView.alpha = 0.0
        }, completion: nil)
    }
}

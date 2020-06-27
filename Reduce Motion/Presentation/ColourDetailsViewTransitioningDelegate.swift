//
//  ColourDetailsViewTransitioningDelegate.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 24/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The transitioning delegate to use when presenting a
/// `ColourDetailsViewController`.
final class ColourDetailsViewTransitioningDelegate: NSObject {
    private let sourceRect: CGRect
    
    init(sourceRect: CGRect) {
        self.sourceRect = sourceRect
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ColourDetailsViewTransitioningDelegate: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CentreSquarePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard UIAccessibility.isReduceMotionEnabled == false else {
            return CrossFadeTransitionAnimator()
        }
        return BouncyTransformTransitionAnimator(sourceRect: sourceRect)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard UIAccessibility.isReduceMotionEnabled == false else {
            return CrossFadeTransitionAnimator()
        }
        return BouncyTransformTransitionAnimator(sourceRect: sourceRect)
    }
}

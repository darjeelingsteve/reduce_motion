//
//  CrossFadeTransitionAnimator.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 24/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The transition animator used to present and dismiss view controllers with a
/// simple cross fade animation.
final class CrossFadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)!
        let isPresenting = toViewController.isBeingPresented
        
        if isPresenting {
            transitionContext.containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if isPresenting {
                toViewController.view.alpha = 1
            } else {
                transitionContext.viewController(forKey: .from)!.view.alpha = 0
            }
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

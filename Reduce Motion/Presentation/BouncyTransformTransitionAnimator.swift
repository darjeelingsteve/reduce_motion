//
//  BouncyTransformTransitionAnimator.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 24/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The transition animator used to present and dismiss view controllers to and
/// from a source rectangle, with a bouncy effect.
final class BouncyTransformTransitionAnimator: NSObject {
    
    /// The styles available for `BouncyTransformTransitionAnimator`.
    ///
    /// * `present` - The style to use when presenting a view controller.
    /// * `dismiss` - The style to use when dismissing a view controller.
    enum Style {
        case present
        case dismiss
    }
    
    private let style: Style
    private let sourceRect: CGRect
    
    init(style: Style, sourceRect: CGRect) {
        self.style = style
        self.sourceRect = sourceRect
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension BouncyTransformTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return style.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        style.performPreAnimationConfiguration(using: transitionContext, sourceRect: sourceRect)
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
            self.style.addAlphaChangeKeyFrameAnimations(using: transitionContext)
        }, completion: nil)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: style.springDamping, initialSpringVelocity: 18, options: [], animations: {
            self.style.performTransitionAnimations(using: transitionContext, sourceRect: self.sourceRect)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

private extension BouncyTransformTransitionAnimator.Style {
    var transitionDuration: TimeInterval {
        switch self {
        case .present:
            return 0.5
        case .dismiss:
            return 0.4
        }
    }
    
    var springDamping: CGFloat {
        switch self {
        case .present:
            return 0.8
        case .dismiss:
            return 1.0
        }
    }
    
    func performPreAnimationConfiguration(using transitionContext: UIViewControllerContextTransitioning, sourceRect: CGRect) {
        switch self {
        case .present:
            let toViewController = transitionContext.viewController(forKey: .to)!
            transitionContext.containerView.addSubview(toViewController.view)
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            toViewController.view.center = CGPoint(x: sourceRect.midX, y: sourceRect.midY)
            toViewController.view.transform = CGAffineTransform.scaleTransformForTransitioning(fromSize: toViewController.view.frame.size, toSize: sourceRect.size)
        case .dismiss:
            break
        }
    }
    
    func addAlphaChangeKeyFrameAnimations(using transitionContext: UIViewControllerContextTransitioning) {
        switch self {
        case .present:
            break
        case .dismiss:
            let fromViewController = transitionContext.viewController(forKey: .from)!
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                fromViewController.view.alpha = 0
            }
        }
    }
    
    func performTransitionAnimations(using transitionContext: UIViewControllerContextTransitioning, sourceRect: CGRect) {
        switch self {
        case .present:
            let toViewController = transitionContext.viewController(forKey: .to)!
            toViewController.view.transform = .identity
            let toViewControllerFinalFrame = transitionContext.finalFrame(for: toViewController)
            toViewController.view.center = CGPoint(x: toViewControllerFinalFrame.midX, y: toViewControllerFinalFrame.midY)
        case .dismiss:
            let fromViewController = transitionContext.viewController(forKey: .from)!
            fromViewController.view.transform = CGAffineTransform.scaleTransformForTransitioning(fromSize: fromViewController.view.frame.size, toSize: sourceRect.size)
            fromViewController.view.center = CGPoint(x: sourceRect.midX, y: sourceRect.midY)
        }
    }
}

private extension CGAffineTransform {
    static func scaleTransformForTransitioning(fromSize: CGSize, toSize: CGSize) -> CGAffineTransform {
        return CGAffineTransform(scaleX: toSize.width / fromSize.width, y: toSize.height / fromSize.height)
    }
}
